# Fluent-bit Daemonset for Kubernetes Logging

[Fluent-bit](http://fluentbit.io/) daemonset dependencies for Kubernetes logging. The docker image for this repo is located at: quay.io/samsung_cnct/k2-logging-fluent-bit-daemonset.

Currently this daemonset reads Docker logs from var/log/containers, adds Kubernetes pod metadata and writes to a zookeeper/Kafka component.

## Bootstrap
```
kubectl create -f fluent-bit.yaml
```

## Plugins

#### Kubernetes Metadata Filter

This filter adds the following data into the body of the log.
* namespace
* pod id
* pod name
* labels
* host
* container name
* docker container id

For more information on the filter or to see a list of configuration options: http://fluentbit.io/documentation/0.11/filter/kubernetes.html

## Monitor Resource Consumption in Container

There is an optional script in the init directory to monitor resource usage for Fluent-bit running in your cluster. By modifying your Dockerfile the script will pull CPU and memory consumption constantly. To use the script, replace the last line in the Dockerfile with:

```
CMD ["/start.sh"]
```

Rebuild your docker image and redeploy the daemonset with new docker image. The script will run, you can stress-test your logging system and when you want to examine the data you can pipe the logs from your daemonsets into a file (on your local machine) with:

```
$ kubectl logs Fluent-bit-daemon-example >> logs.dat
```

Grep the file for your metrics with:

```
$ grep "\[metrics\]" <logs.dat> | cut -d" " -f2,3 > <clean.dat>
```

You will have two columns, CPU & MEM, which you can graph or pinpoint peak usage related to your stress testing. 

GNUPLOT is an easy way to quickly visualize the data. Start GNUPLOT (install if necessary) and run: 

`gnuplot> plot '<clean.dat>' using 1 with lines` for CPU usage
`gnuplot> plot '<clean.dat>' using 2 with lines` for MEM usage