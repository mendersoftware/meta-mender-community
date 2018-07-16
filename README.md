# Mender community integration layers


## Google repo tool

To simplify fetching sources and setting up the build environment this layer
relies on the Google [repo](https://source.android.com/setup/develop/repo) tool,
which allows fetching sources from multiple location in a single command. This
tools is widely used within the Yocto eco-system and we have simply adopted
the "best practice" from this.

The following is a one time installation

Install the repo utility:

    $ mkdir ~/bin
    $ curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    $ chmod a+x ~/bin/repo

You should also add the following to your `.bashrc` or equivalent, for convenience.

    PATH=${PATH}:~/bin

## Contributing

We welcome and ask for your contribution. If you would like to contribute to
Mender, please read our guide on how to best get started [contributing code or
documentation](https://github.com/mendersoftware/mender/blob/master/CONTRIBUTING.md).

## License

Mender is licensed under the Apache License, Version 2.0. See
[LICENSE](https://github.com/mirzak/meta-mender-community/blob/master/LICENSE) for the
full license text.

## Connect with us

* Join our [Google
  group](https://groups.google.com/a/lists.mender.io/forum/#!forum/mender)
* Follow us on [Twitter](https://twitter.com/mender_io?target=_blank). Please
  feel free to tweet us questions.
* Fork us on [Github](https://github.com/mendersoftware)
* Email us at [contact@mender.io](mailto:contact@mender.io)
