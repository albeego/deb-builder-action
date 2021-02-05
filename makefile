build:
	docker build . -t albeego/deb-builder-action:0.0.1
	docker build . -t albeego/deb-builder-action:latest
push:
	docker push albeego/deb-builder-action:0.0.1
	docker push albeego/deb-builder-action:latest