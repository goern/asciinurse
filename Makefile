DOCS=ra-template-v2

all: $(DOCS) html

html: $(DOCS)
	asciidoctor -r asciidoctor-diagram $(DOCS).adoc

clean:
	rm -f $(DOCS).html
