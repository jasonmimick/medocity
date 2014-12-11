Medocity-InterSystems POC
-------------------------

Initial Plans:

Medocity -> HealthShare

* Patient record updated in Medocity
* Modicity POSTs patient id into HS
* HS then callback get GET request to pull patient data
* This is then routed into an HL7 message (probably A08) and also some flavor of a CDA document (CCD/C-CDA/etc)
* For the POC we could with send these messages to a filesystem, another instance of HS or possible a mocked up instance of something like OpenEMR

HealthShare -> Medocity

* HS receives an HL7 A08 patient update (simulating an update from some EMR)
* HS can POST a patient ID into Mediocrity
* Medocity can callback with a GET to pull the patient data (format here will be HS own “SDA” format - but this is open for design discussion)
* Users can then view updated data in Medocity

To run the 'mock' Medocity
```bash
node simple-node-httpserver.js 45678
```

To send HL7 into HealthShare
```bash
curl -v -X POST localhost:56788 --data-binary @xx01.hl7
```
will send one file 'xx01.hl7'

To send lots of files
```bash
find . -name "*.hl7" -print0 | xargs -0 -P 4 -I file curl -v -X POST localhost:56788 --data-binary @file
```

