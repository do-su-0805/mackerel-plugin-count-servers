# mackerel-plugin-count-servers

## Usage
1. Setting your `mackerel-agent.conf`

```
[plugin.metrics.Example-servers]
command = ["mackerel-plugin-count-servers","-s","Example"]
```

2. send data by `mackerel-plugin-count-servers` 
```
Example.role1.working   2   1552897222
Example.role1.poweroff  2   1552897222
Example.role1.maintenance   2   1552897222
Example.role1.standby   2   1552897222
```
