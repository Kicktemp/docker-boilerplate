#Docker-Boilerplate


## Docker-Compose

### docker-compose.yml

Die default docker-compose ist für alle PHP Projekte geeignet.

Beim start wird die datei ``entrypoint.d/boot.sh`` gestartet.


### docker-compose.typo3.yml

Diese docker-compose beinhaltet kleine optimierungen für TYPO3-Projekte, so wie einen automaitschen download des Sources.

Beim start wird die datei ``entrypoint.d/boot.typo3.sh`` gestartet.

Die TYPO3 Verion muss in der env-Variable **TYPO3_VERSION** angegeben werden.


## Enviroment-Variablen

In der Datei **.env** werden folgende Variablen angegeben:


### Allgemeine

**PROJECT_NAME**: Projekt-Name, welcher für die URL genutzt wird ([PROJECT_NAME].lvh.me)
 
### TYPO3 spezifische

**TYPO3_VERSION**: Die genaue Version von TYPO3, wird genutzt um initial die sources herunterzuladen und um den richtigen Ordner zu linken.
 
**TYPO3_CONTEXT**: Sollte lokal nicht geändert werden, so dass die richtigen settings gealden werden.

-----

## Shell-Scripts
Es gibt folgende Funtkionen: 

die Scripte werden folgendermaßen aufgerufen:

<code>./[]SCRIPT-NAME].sh [BEFEHL]</code>

### backup.sh
Backup Scripts, welche die Daten in den Ordner **Backup** legen.

**mysql** Sichert die mySQL Datenbank

**solr**  Sichert den Solr-Server

-----

### restore.sh
Wiederherstellungs Scrupts, welche die Daten aus dem Ordner **Backup** wiederherstellen.

**mysql** Wiederherstellen der mySQL Datenbank

**solr** Wiederherstellen des Solr-backups

-----

### typo3.sh
TYPO3 shell Scripts.

**clean** Löscht den Inhalt von typo3temp

**scheduler** Startet den TYPO3-Scheduler

**referenceindex** Baut den referenceindex neu auf.

