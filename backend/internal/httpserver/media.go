package httpserver

import (
	"RPG-manager/backend/internal/media"
	"errors"
	"io"
	"mime"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (a *API) uploadImage(c *gin.Context) {
	kind, _, err := mime.ParseMediaType(c.GetHeader("Content-Type"))
	if err != nil || kind != "multipart/form-data" {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	// Keep the bounded form in memory; do not leave uploaded temporary files.
	if err := c.Request.ParseMultipartForm(media.MaxBytes + (64 << 10)); err != nil {
		var tooLarge *http.MaxBytesError
		status := http.StatusBadRequest
		if errors.As(err, &tooLarge) {
			status = http.StatusRequestEntityTooLarge
		}
		writeError(c, status, "INVALID_REQUEST")
		return
	}
	form := c.Request.MultipartForm
	if form == nil || len(form.File) != 1 || len(form.File["file"]) != 1 || len(form.Value) != 1 || len(form.Value["purpose"]) != 1 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	purpose := form.Value["purpose"][0]
	if purpose != "profile" && purpose != "character" && purpose != "campaign" {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if _, err := a.account.Profile(c.Request.Context()); err != nil {
		a.failure(c, err, "USER_NOT_FOUND")
		return
	}
	file, err := form.File["file"][0].Open()
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	data, readErr := io.ReadAll(io.LimitReader(file, media.MaxBytes+1))
	closeErr := file.Close()
	if readErr != nil {
		a.failure(c, readErr, "CONTENT_NOT_FOUND")
		return
	}
	if closeErr != nil {
		a.failure(c, closeErr, "CONTENT_NOT_FOUND")
		return
	}
	if len(data) > media.MaxBytes {
		writeError(c, 413, "INVALID_REQUEST")
		return
	}
	imageURL, _, err := a.media.PutImage(c.Request.Context(), "users/"+a.userID+"/"+purpose, data)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, gin.H{"imageUrl": imageURL})
}
