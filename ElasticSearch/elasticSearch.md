# Elastic Search
Elasticsearch can be downloaded directly from elastic.co in zip, tar.gz, deb, or rpm packages. For Ubuntu, it's best to use the deb (Debian) package which will install everything you need to run Elasticsearch.

### Downloading and Installing Elasticsearch for ubuntu 18.04
- Download the latest Elasticsearch version, which is 2.3.1 at the time of writing.
- Set the key for it.
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add
```
- Add the Elastic source list to the sources.list.d directory, where APT will look for new sources

```
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
```
- GIve update to ubuntu apps.
```
sudo apt update
```
- To install ElasticSearch
```
sudo apt install elasticsearch
```
- 
- To make sure Elasticsearch starts and stops automatically with the server, add its init script to the default runlevels.
```
sudo systemctl enable elasticsearch.service
```

### Configuring Elasticsearch
- To start editing the main elasticsearch.yml configuration file with nano or your favorite text editor.
```
sudo nano /etc/elasticsearch/elasticsearch.yml
```
- Remove the # character at the beginning of the lines for cluster.name and node.name to uncomment them, and then update their values. Your first configuration changes in the /etc/elasticsearch/elasticsearch.yml file should look like this:
```
. . .
cluster.name: mycluster1
node.name: "My First Node"
path.data: /prasanna/Mytest/
. . .
```
- Once you make all the changes, save and exit the file. Now you can start Elasticsearch for the first time.
```
sudo systemctl start elasticsearch
```

### Kibana Installation :
- Install Kibana : ```sudo apt install kibana```
- Start kibana service : ```sudo systemctl enable kibana || sudo systemctl start kibana```
- Set password for kibana : ```echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users```
- To open kibana, type on browser ```http://localhost:5601```

### Example:
```
curl -X POST 'http://localhost:9200/tutorial/helloworld/1' -d '{ "message": "Hello World!" }'
OUTPUT :
{"_index":"tutorial","_type":"helloworld","_id":"1","_version":1,"_shards":{"total":2,"successful":1,"failed":0},"created":true}
```
- Check Health : ```curl -X GET "localhost:9200/_cat/health?v```
- List all nodes : ```curl -X GET "localhost:9200/_cat/nodes?v"```
- Display all index : ```curl -X GET "localhost:9200/_cat/indices?v"```
- Create a index : ```curl -X PUT "localhost:9200/customer?pretty"curl -X GET "localhost:9200/_cat/indice```
- Index and Query : ```curl -X PUT "localhost:9200/customer/_doc/1?pretty" -H``` ```'Content-Type: application/json' -d'``````{"name": "John Doe"Index and Query}```
- Retire the doc : ```curl -X GET "localhost:9200/customer/_doc/1?pretty"```
- Delete the doc : ```curl -X DELETE "localhost:9200/customer?pretty"``` ```curl -X GET "localhost:9200/_cat/indices?v"```
- Indexing/Replacing Document : ```curl -X PUT``` ```"localhost:9200/customer/_doc/1?pretty" -H 'Content-Type: application/json' -d'```					```{"name": "Jane Doe"}'```
- Update doc : ```curl -X POST "localhost:9200/customer/_doc/1/_update?pretty" -H 'Content-Type: application/json' -d'``` ```{"doc": { "name": "Jane Doe" }  updatedocs } '```