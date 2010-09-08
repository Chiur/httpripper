DESTDIR=/
PROJECT=httpripper_

all:
	@echo "make source - Create source package"
	@echo "make install - Install on local system"
	@echo "make buildrpm - Generate a rpm package"
	@echo "make builddeb - Generate a deb package"
	@echo "make clean - Get rid of scratch and byte files"

source:
	python setup.py sdist $(COMPILE)

install:
	python setup.py install --root $(DESTDIR) $(COMPILE)

buildrpm:
	python setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall

builddeb:
	# build the source package in the parent directory
	# then rename it to project_version.orig.tar.gz
	python setup.py sdist $(COMPILE) --dist-dir=../ --prune
	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	# build the package
	dpkg-buildpackage -i -I -rfakeroot

clean:
	python setup.py clean
	$(MAKE) -f $(CURDIR)/debian/rules clean
	rm -rf build/ MANIFEST
	find . -name '*.pyc' -delete
