# Neo4j

### Neo4j.conf file:
- We need to comment : ```dbms.directories.import=/var/lib/neo4j/import```.
- It should be commented, so that we can use file from outer repository on Neo4j.
- Open neo4j.conf file in vim editor and add # before it.
- It cannot be changed in normal editors.

### Connecting Excel with Neo4j :
- Extracting node from Excel with single column : ``` load csv with headers from "file:///home/prasanna/Downloads/SkillCounter.csv" as Resumes create (A1:ResNames{Names: Resumes.Names})```.
- Extracting multiple nodes from Excel with single column :  ```load csv with headers from "file:///home/prasanna/Downloads/SkillCounter.csv" as Resumes create (A1:ResNames{Names: Resumes.Names}),(B1:ResSkills{Skills: Resumes.Skills})```.
- Creating relations on nodes from Excel : ```load csv with headers from "file: ///home/prasanna/prasanna/Python-workspace/SkillSetReader.xlsx" as SkillCounter match (a1: ResNames{Names: SkillCounter.Names}), (b1: ResSkill{Skills1: SkillCounter.Skills1})  CREATE (a) - [r: Knows] -> (b)```
  
