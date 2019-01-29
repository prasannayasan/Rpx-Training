### Neo4j
### Installation :
- Neo4j is implemented in Java, so you’ll need to have the Java Runtime Environment (JRE) installed. 
``` sudo apt install default-jre default-jre-headless ```
- First we’ll add the repository key to our keychain.
``` wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add - ```
- Then add the repository to the list of apt sources.
``` echo 'deb http://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list ```
- Finally update the repository information and install Neo4j.
``` sudo apt update ```
```sudo apt install neo4j ```
- The server should have started automatically and should also be restarted at boot. If necessary the server can be stopped with
``` sudo service neo4j stop ```
- Restarted with
``` sudo service neo4j start ```

### Accessing Neo4j :
- Link to dataserver - http://localhost:7474/browser/.
- Give username and password (neo4j and neo4j).
- On the next page we set password.

### Working on Neo4j :
- On the localhost page we can write Cyber query to execute the graphs

#### Cyber queries :
- Create a node  **CREATE(node)**.

- Create node along with label : **CREATE (node:label)**.

- Create node with multiple labels :  **CREATE (node:label1:label2:. . . . labeln)**.

- Create node with properties : **CREATE (Dhawan:player{name: "Shikar Dhawan", YOB: 1985, POB: "Delhi"})**.

- Create node with properties & return them  : **CREATE (Rina:Tester{name: "Gayathrri", YOB: "1997"}) RETURN Rina** .
- Creating Relationship on Exsisting nodes   : **MATCH (a:LabeofNode1), (b:LabeofNode2) 	WHERE a.name = "nameofnode1" AND b.name = " nameofnode2" 	CREATE (a)-[: Relation]->(b) 	 RETURN a,b**.

- Create node relation with label & properties : **CREATE (node1)-[label:Rel_Type {key1:value1, key2:value2, . . . n}]-> (node2)** .

- Creaating a complete path :  **CREATE p = (Node1{properties})-[:Relationship_Type]->	(Node2 {properties})[:Relationship_Type]->(Node3 {properties})	RETURN p**.

- Delete the node : **MATCH (lily:info {name: "lily", DOB: 1988, POB: "Delhi"})**
