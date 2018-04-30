# Installing OpenStorage SDK

## Clients
Currently, OpenStorage provides Python, Ruby, Golang, and JavaScript bindings
under the [`api/client/sdk`](https://github.com/libopenstorage/openstorage/tree/master/api/client/sdk)
directory. If your client is not available, please feel free to generate one
from the [`api.proto`](https://github.com/libopenstorage/openstorage/blob/master/api/api.proto)
file on OpenStorage.

### Golang
For Golang, simply import `github.com/libopenstorage/openstorage/api` in your
sources. Here is a full example:

```go
package main

import (
        "context"
        "fmt"
        "os"

        "github.com/libopenstorage/openstorage/api"
        "google.golang.org/grpc"
)

func main() {
        conn, err := grpc.Dial("localhost:9100", grpc.WithInsecure())
        if err != nil {
                fmt.Println(err)
                os.Exit(1)
        }

        c := api.NewOpenStorageClusterClient(conn)
        r, err := c.Enumerate(context.Background(), &api.ClusterEnumerateRequest{})
        if err != nil {
                fmt.Println(err)
                os.Exit(1)
        }
        fmt.Println(r)
}
```

### Python
Python libraries are available [`api/client/sdk/python`](https://github.com/libopenstorage/openstorage/tree/master/api/client/sdk).
You will need the files `api*.py` copied to your path.  Here is a full example:

```python
#
# Install:
#   virtualenv sdk
#   source sdk/bin/activate
#   pip install grpcio grpcio-tools
#
# Then copy the api*.py files to the directory as your client
#   
# More info: https://grpc.io/docs/quickstart/python.html
#
import grpc
import api_pb2
import api_pb2_grpc

# Setup connection
channel = grpc.insecure_channel('localhost:9100')
client = api_pb2_grpc.OpenStorageClusterStub(channel)

# Get cluster information
en_resp = client.Enumerate(api_pb2.ClusterEnumerateRequest())
print en_resp

# Get node info
n_resp = client.Inspect(api_pb2.ClusterInspectRequest(node_id=en_resp.cluster.nodes[0].id))
print n_resp
```

We may some day provide a python `pip` package, but do not have one at the moment.

### Ruby and Javascript
Ruby and Javascript clients are also located in _api/client/sdk_.

## Mock SDK Server
OpenStorage provides mock SDK server as a container which can be run using the
command:

```
$ docker run -d -p 9100:9100 openstorage/mock-sdk-server
```

This will run OpenStorage server with an in-memory driver implementation called
`fake`. You can then point your gRPC client to `localhost:9100`.