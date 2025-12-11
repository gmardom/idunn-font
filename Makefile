IOSEVKA_COMMIT := f2cab61c0de33c8c7158ede37c6241e04b5cc22b

all: mono sans serif

mono: IdunnMono
sans: IdunnSans
serif: IdunnSerif

dist: IdunnMono.zip IdunnSans.zip IdunnSerif.zip

clean:
	rm -rf Iosevka
	rm -rf IdunnMono IdunnSans IdunnSerif
	rm -f IdunnMono.zip IdunnSans.zip IdunnSerif.zip

Iosevka.zip:
	curl -L "https://github.com/be5invis/Iosevka/archive/$(IOSEVKA_COMMIT).zip" -o Iosevka.zip

Iosevka: Iosevka.zip
	unzip -qq Iosevka.zip
	mv Iosevka-$(IOSEVKA_COMMIT) Iosevka
	cd Iosevka && npm install

%: %.toml | Iosevka
	cat $< > Iosevka/private-build-plans.toml
	cd Iosevka && npm run build -- contents::$@
	mv -f Iosevka/dist/$@ $@

%.zip: %
	zip -r $@ $<

.PHONY: all mono sans serif dist clean
