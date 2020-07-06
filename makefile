build:
	docker build . -t albeego/deb-builder-action:0.0.1
push:
	docker push albeego/deb-builder-action:0.0.1