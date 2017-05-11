# peco-s3.zsh

Zsh command to cat file in a s3 bucket by filtering with peco

## Installation

* Save `peco-s3.zsh` somewhere
* Load it in your `~/.zshrc`
  * `source /path/to/peco-s3.zsh`

## Usage

```
# List all buckets
$ peco-s3

# Show files in a directory recursively
$ peco-s3 --recursive
$ peco-s3 -r

# Inside a bucket
$ peco-s3 bucket

# Inside a directory in a bucket
$ peco-s3 bucket/dir/subdir
```

## Requires

* [peco](https://github.com/peco/peco)
* [awscli](https://pypi.python.org/pypi/awscli)
* [s3cat](https://pypi.python.org/pypi/s3cat)

## License

The MIT License
