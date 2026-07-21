# kitchen-dokken's data image
This repo creates a build of the data image kitchen-dokken wants to create when you're running with a remote docker or inside docker

You can find the original code to create this image in their repo [Dokken::Helpers#data_dockerfile](https://github.com/test-kitchen/kitchen-dokken/blob/v2.23.1/lib/kitchen/helpers.rb#L60-L89).

## Usage
In your `kitchen.yaml` set the data image to use this image. You also need to pull the data image before
kitchen runs create (since kitchen-dokken will try to build the image if it doesn't exist locally).

```yaml
driver:
  name: dokken
  data_image: ghcr.io/b-dean/kitchen-dokken-data-image

lifecycle:
  pre_create:
    - docker pull ghcr.io/b-dean/kitchen-dokken-data-image
```

## Caveats
In kitchen-dokken they create a volume in the image pointing to the
[`resolved_root_path`](https://github.com/test-kitchen/kitchen-dokken/blob/v2.23.1/lib/kitchen/helpers.rb#L298-L300)
which ends up being

```rb
def resolved_root_path
  instance.provisioner[:root_path] || "/opt/kitchen"
end
```

They could have resolved this path and made this volume at container creation, but they did not.
So it is in the image. This means if you set a different root path, this won't work for you.
Hopefully they'll change that.
