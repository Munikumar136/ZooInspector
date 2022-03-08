===============================================================
Instructions to launch ZooInspector Client
===============================================================

Please extract the "zooinspector-pkg-tls1.2.zip" file published and run the zooinspector.bat file from "zooinspector-pkg-tls1.2/bin/" directory.

===============================================================
Informaiton on SSL/Non-SSL client connectivity to ZK servers
===============================================================

SSL (Remote ZK servers) or Non-SSL (ZK intances running on local machines for testing)

"zookeeper.client.secure" is the flag to be used to an SSL mode (set this flag to "true") for remote ZK servers or Non-secure connection (set the flag to "false") to ZK on local machine.

Please update this flag as per your connection mode requirement on zooinspector.bat file and launch it.

-Dzookeeper.client.secure=true

NOTE: 
1. We haven't updated "bin/zooinspector.sh" file yet, but all properties are updated on "bin/zooinspector.bat" file. If anybody needs zooinspector.sh file , please mimic the setings from zooinspector.bat file wrt ZK properties, all neceessary dependencies. 
2. This ZooInspector client uses non-prod SSL keyStore and trustStores to connect to non-prod (DEV, INT, QA, PP, PERF and all other non-prod environments).



Please reach out to ODTSupport@travelport.com for any additional support.