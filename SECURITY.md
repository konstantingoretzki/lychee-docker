## Security notes regarding our container

### CVE-2019-5021
As our Lychee image uses the alpine version of nginx, containers using our image with version v3.2.12 and lower are affected by [CVE-2019-5021](https://alpinelinux.org/posts/Docker-image-vulnerability-CVE-2019-5021.html). 
If you currently use v3.2.14 or v3.2.13 (or any future version), you are good to go since these version are using alpine v3.9.2 or newer and are therefore not affected.

Please note that the CVE is based on theoretical exploitation. Lychee does not use any system authentication inside the container, so a root escalation should not be possible.

To be as secure as possible though, we did remove any affected older version and patched the current one (v3.2.14) to the newest nginx-alpine version that uses alpine:3.9.3.

##### What should you do?
If you use our Lychee container in production, update to v3.2.14, which will be the only available version for now.