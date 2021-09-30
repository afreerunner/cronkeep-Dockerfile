Dockerfile for [cronkeep/cronkeep](https://github.com/cronkeep/cronkeep)

## Test
### Only cronkeep
- `docker pull afreerunner/cronkeep`
- `docker run --it --rm -p 8081:80 --name=cronkeep afreerunner/cronkeep`
### cronkeep + Python3.8
- `docker pull afreerunner/cronkeep:python`
- `docker run --it --rm -p 8081:80 --name=cronkeep afreerunner/cronkeep:python python3`

Then open http://127.0.0.1:8081 to access the web control pannel.

![image](https://user-images.githubusercontent.com/15151527/135240086-b335a079-97a8-41d6-9a4b-610d7bd9517c.png)
![image](https://user-images.githubusercontent.com/15151527/135240212-350f2cca-f7af-40ed-bf48-6edd507b0d8d.png)
