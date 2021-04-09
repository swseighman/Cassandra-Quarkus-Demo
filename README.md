# Cassandra Client with Quarkus

### Connecting to Apache Cassandra or DataStax Enterprise (DSE)

The main properties to configure are: `contact-points`, to access the Cassandra database; `local-datacenter`, which is required by the driver and optionally, the `keyspace` to bind.

A sample configuration should look like this:

```
quarkus.cassandra.contact-points={cassandra_ip}:9042 quarkus.cassandra.local-datacenter={dc_name} quarkus.cassandra.keyspace={keyspace}
```

**NOTE:** To configure the IP for Linux on WSL2, identify the IP by executing the following command:

```
$ ping $(hostname).local
PING sws-ryzen (172.30.112.1) 56(84) bytes of data.
```

In this example, we are using a single instance running on localhost *(IP address from above)*, and the keyspace containing our data is k1:

```
quarkus.cassandra.contact-points=172.30.112.1:9042 
quarkus.cassandra.local-datacenter=datacenter1 
quarkus.cassandra.keyspace=k1
```

Start the Cassandra database container:
```
$ docker run --name local-cassandra-instance -p 9042:9042 -d cassandra
```

Next you need to create the keyspace and table that will be used by your application. If you are using Docker, run the following commands:

```
$ docker exec -it local-cassandra-instance cqlsh -e "CREATE KEYSPACE IF NOT EXISTS k1 WITH replication = {'class':'SimpleStrategy', 'replication_factor':1}"
$ docker exec -it local-cassandra-instance cqlsh -e "CREATE TABLE IF NOT EXISTS k1.fruit(name text PRIMARY KEY, description text)"
```

You can also use the CQLSH utility to interactively interrogate your database:

```
$ docker exec -it local-cassandra-instance cqlsh
Connected to Test Cluster at 127.0.0.1:9042.
[cqlsh 5.0.1 | Cassandra 3.11.10 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh> select * from k1.fruit;

 name   | description
--------+------------------
  apple |    red and tasty

(4 rows)
cqlsh> exit
```
Run `mvn clean package` and then to start the application:
```
$ java -jar ./target/cassandra-quarkus-quickstart-*-runner.jar
```

Or run the application in dev mode: `mvn clean quarkus:dev`.

```
$ curl --header "Content-Type: application/json" --request POST --data '{"name":"apple","description":"red and tasty"}' http://localhost:8080/fruits
```

```
$ http http://localhost:8080/fruits
HTTP/1.1 200 OK
Content-Length: 197
Content-Type: application/json

[
    {
        "description": "red and tasty",
        "name": "apple"
    }
]
```

```
$ http http://localhost:8080/q/health
HTTP/1.1 200 OK
content-length: 410
content-type: application/json; charset=UTF-8

{
    "checks": [
        {
            "data": {
                "clusterName": "Test Cluster",
                "cqlVersion": "3.4.4",
                "datacenter": "datacenter1",
                "numberOfNodes": 1,
                "releaseVersion": "3.11.10"
            },
            "name": "DataStax Apache Cassandra Driver health check",
            "status": "UP"
        }
    ],
    "status": "UP"
}
```
To access the REST UI, browse to: [http://localhost:8080/fruits.html](http://localhost:8080/fruits.html)

![](//wsl$/Ubuntu/home/sseighma/code/cassandra-quarkus/Cassandra-Quarkus-Demo/images/REST-UI.png)

To access the Reactive UI, browse to: 
[http://localhost:8080/reactive-fruits.html](http://localhost:8080/reactive-fruits.html)

![](//wsl$/Ubuntu/home/sseighma/code/cassandra-quarkus/Cassandra-Quarkus-Demo/images/Reactive-UI-1.png)

You can also add fruit to the database via the UI:

![](//wsl$/Ubuntu/home/sseighma/code/cassandra-quarkus/Cassandra-Quarkus-Demo/images/Reactive-UI-2.png)

### Create a Native Image Executable
To build a native image, execute the following command:

```
$ mvn clean package -Dnative
```

Once the compilation is finished, you can run the native executable by executing the following command:

```
./target/cassandra-quarkus-quickstart-*-runner
```

You can then browse to [http://localhost:8080/fruits.html](http://localhost:8080/fruits.html) and access the application as noted earlier.

### Create Container Images

```
$ docker build -f src/main/docker/Dockerfile.distroless -t quarkus/cassandra-client-distroless .
```

