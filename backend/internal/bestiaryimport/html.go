package bestiaryimport

import (
	"bytes"
	"fmt"
	"net/url"
	"strings"

	"golang.org/x/net/html"
)

func attr(n *html.Node, key string) string {
	for _, a := range n.Attr {
		if a.Key == key {
			return a.Val
		}
	}
	return ""
}
func hasClass(n *html.Node, class string) bool {
	for _, value := range strings.Fields(attr(n, "class")) {
		if value == class {
			return true
		}
	}
	return false
}
func walk(n *html.Node, visit func(*html.Node) bool) {
	if !visit(n) {
		return
	}
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		walk(c, visit)
	}
}
func content(n *html.Node) string {
	var b strings.Builder
	walk(n, func(c *html.Node) bool {
		if c.Type == html.ElementNode && (c.Data == "script" || c.Data == "style" || c.Data == "sup" || hasClass(c, "mw-editsection")) {
			return false
		}
		if c.Type == html.TextNode {
			b.WriteString(c.Data)
			b.WriteByte(' ')
		}
		return true
	})
	return strings.Join(strings.Fields(b.String()), " ")
}
func parseRoot(data []byte) (*html.Node, *html.Node, error) {
	doc, err := html.Parse(bytes.NewReader(data))
	if err != nil {
		return nil, nil, err
	}
	var root *html.Node
	walk(doc, func(n *html.Node) bool {
		if hasClass(n, "mw-parser-output") && root == nil {
			root = n
			return false
		}
		return true
	})
	if root == nil {
		return nil, nil, fmt.Errorf("article content missing (access challenge or changed HTML)")
	}
	return doc, root, nil
}
func articleURL(raw string) string {
	base, _ := url.Parse(IndexURL)
	u, err := base.Parse(raw)
	if err != nil || u.Scheme != "https" || u.Host != "ordemparanormal.fandom.com" || !strings.HasPrefix(u.Path, "/wiki/") || strings.Contains(strings.TrimPrefix(u.Path, "/wiki/"), ":") {
		return ""
	}
	u.RawQuery = ""
	u.Fragment = ""
	return u.String()
}
func indexImage(n *html.Node) string {
	for p := n.Parent; p != nil; p = p.Parent {
		if hasClass(p, "moldura-container") {
			imageURL := ""
			walk(p, func(c *html.Node) bool {
				if c.Data == "img" && imageURL == "" {
					raw := attr(c, "data-src")
					if raw == "" {
						raw = attr(c, "src")
					}
					u, err := url.Parse(raw)
					if err == nil && u.Scheme == "https" && u.Host == "static.wikia.nocookie.net" {
						if cut := strings.Index(u.Path, "/revision/"); cut >= 0 {
							u.Path = u.Path[:cut] + "/revision/latest"
							u.RawPath = ""
						}
						imageURL = u.String()
					}
				}
				return true
			})
			return imageURL
		}
	}
	return ""
}
func parseIndex(data []byte) ([]Entry, error) {
	_, root, err := parseRoot(data)
	if err != nil {
		return nil, err
	}
	entries := []Entry{}
	seen := map[string]int{}
	sections := [5]string{}
	walk(root, func(n *html.Node) bool {
		if n.Type != html.ElementNode {
			return true
		}
		if n.Data == "aside" || hasClass(n, "navbox") || hasClass(n, "toc") {
			return false
		}
		if len(n.Data) == 2 && n.Data[0] == 'h' && n.Data[1] >= '2' && n.Data[1] <= '6' {
			level := int(n.Data[1] - '2')
			sections[level] = content(n)
			for i := level + 1; i < len(sections); i++ {
				sections[i] = ""
			}
		}
		if n.Data != "a" {
			return true
		}
		raw := articleURL(attr(n, "href"))
		name := content(n)
		if raw == "" || raw == IndexURL || name == "" {
			return true
		}
		gallery := false
		for p := n.Parent; p != nil && p != root; p = p.Parent {
			for _, cl := range strings.Fields(attr(p, "class")) {
				if strings.Contains(cl, "gallery") || strings.Contains(cl, "lightbox-caption") || cl == "moldura-link" {
					gallery = true
				}
			}
		}
		if !gallery {
			return true
		}
		current := []string{}
		for _, s := range sections {
			if s != "" {
				current = append(current, s)
			}
		}
		section := strings.Join(current, " / ")
		nonCanonical := strings.Contains(normalize(section), "naocanonico")
		key := raw + "|" + normalize(name)
		if index, ok := seen[key]; ok {
			if !contains(entries[index].Sections, section) {
				entries[index].Sections = append(entries[index].Sections, section)
			}
			entries[index].NonCanonical = entries[index].NonCanonical || nonCanonical
			return true
		}
		seen[key] = len(entries)
		entries = append(entries, Entry{Name: name, URL: raw, IndexImage: indexImage(n), Sections: []string{section}, NonCanonical: nonCanonical, Decision: "pending", Candidates: []Threat{}, Problems: []string{}})
		return true
	})
	if len(entries) == 0 {
		return nil, fmt.Errorf("no creature galleries found; inspect index HTML before changing selectors")
	}
	return entries, nil
}
func contains(list []string, v string) bool {
	for _, s := range list {
		if s == v {
			return true
		}
	}
	return false
}
func parseArticle(data []byte, e *Entry) error {
	doc, root, err := parseRoot(data)
	if err != nil {
		return err
	}
	walk(doc, func(n *html.Node) bool {
		if n.Data == "link" && attr(n, "rel") == "canonical" {
			e.CanonicalURL = articleURL(attr(n, "href"))
		}
		return true
	})
	section := ""
	paragraphs := []string{}
	walk(root, func(n *html.Node) bool {
		if n.Type != html.ElementNode {
			return true
		}
		if n.Data == "script" || n.Data == "style" || hasClass(n, "navbox") || hasClass(n, "toc") {
			return false
		}
		inInfobox := false
		for p := n.Parent; p != nil && p != root; p = p.Parent {
			if p.Data == "aside" {
				inInfobox = true
				break
			}
		}
		if n.Data == "h2" && !inInfobox {
			section = normalize(content(n))
		}
		if n.Data == "p" && !inInfobox && (section == "" || strings.HasPrefix(section, "aparencia") || strings.HasPrefix(section, "descricao")) {
			text := content(n)
			if len([]rune(text)) >= 80 && len(paragraphs) < 6 {
				paragraphs = append(paragraphs, text)
			}
		}
		if n.Data == "img" && e.ImageSource == "" && (hasClass(n, "pi-image-thumbnail") || hasClass(n, "infobox-image")) {
			raw := attr(n, "data-src")
			if raw == "" {
				raw = attr(n, "src")
			}
			if n.Parent != nil && n.Parent.Data == "a" && attr(n.Parent, "href") != "" {
				raw = attr(n.Parent, "href")
			}
			if u, err := url.Parse(raw); err == nil && u.Scheme == "https" && u.Host == "static.wikia.nocookie.net" {
				e.ImageSource = raw
			}
		}
		return true
	})
	if len(paragraphs) == 0 {
		var lead strings.Builder
		afterInfobox := false
		for n := root.FirstChild; n != nil; n = n.NextSibling {
			if n.Data == "aside" {
				afterInfobox = true
				continue
			}
			if afterInfobox && n.Data == "h2" {
				break
			}
			if afterInfobox {
				lead.WriteString(content(n))
				lead.WriteByte(' ')
			}
		}
		text := strings.Join(strings.Fields(lead.String()), " ")
		if len([]rune(text)) >= 40 {
			paragraphs = append(paragraphs, text)
		}
	}
	e.SourceText = strings.Join(paragraphs, "\n\n")
	if e.SourceText == "" {
		e.Problems = append(e.Problems, "Nenhum texto descritivo identificado; revisar HTML.")
	}
	if e.ImageSource == "" {
		e.Problems = append(e.Problems, "Imagem principal não identificada; revisar infobox.")
	}
	return nil
}
