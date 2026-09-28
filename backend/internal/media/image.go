package media

import (
	"RPG-manager/backend/internal/apperr"
	"bytes"
	"encoding/binary"
	"image"
	_ "image/jpeg"
	_ "image/png"

	_ "golang.org/x/image/webp"
)

const MaxBytes = 10 << 20
const MaxPixels = 25_000_000

func ValidateImage(data []byte) (string, error) {
	if len(data) == 0 || len(data) > MaxBytes {
		return "", apperr.ErrInvalid
	}
	cfg, format, err := image.DecodeConfig(bytes.NewReader(data))
	if err != nil || cfg.Width <= 0 || cfg.Height <= 0 || int64(cfg.Width)*int64(cfg.Height) > MaxPixels {
		return "", apperr.ErrInvalid
	}
	if format != "jpeg" && format != "png" && format != "webp" {
		return "", apperr.ErrInvalid
	}
	// Reject APNG and animated WebP by their container chunks, not filename or MIME.
	if format == "png" {
		for pos := 8; pos+12 <= len(data); {
			n := int64(binary.BigEndian.Uint32(data[pos : pos+4]))
			if int64(pos)+12+n > int64(len(data)) {
				return "", apperr.ErrInvalid
			}
			if string(data[pos+4:pos+8]) == "acTL" {
				return "", apperr.ErrInvalid
			}
			pos += int(n) + 12
		}
	}
	if format == "webp" {
		for pos := 12; pos+8 <= len(data); {
			n := int64(binary.LittleEndian.Uint32(data[pos+4 : pos+8]))
			if int64(pos)+8+n > int64(len(data)) {
				return "", apperr.ErrInvalid
			}
			kind := string(data[pos : pos+4])
			if kind == "ANIM" || kind == "ANMF" {
				return "", apperr.ErrInvalid
			}
			pos += 8 + int(n) + (int(n) % 2)
		}
	}
	if _, _, err := image.Decode(bytes.NewReader(data)); err != nil {
		return "", apperr.ErrInvalid
	}
	return format, nil
}
