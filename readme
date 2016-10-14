Install Eprints
===============

Configure as described on http://wiki.eprints.org/w/Installing_EPrints_3_via_Redhat_RPM

IMPORTANT: Because KMi set up apache to use the user webmgr, you need to add the eprints group to the webmgr account.

To do this, open /etc/group

	sudo vi /etc/group
	
Find the line similar to
	
	eprints:x:10021:apache

add , webmgr to the end like

	eprints:x:10021:apache, webmgr

You will also need to give write access to group

sudo chmod -R 775 /usr/share/eprints/
	
Restart apache


Developer settings
-------

To aid in development, you will want to run the following commands

	bin/epadmin set_developer_mode core on

You can also import some test data like so:

	 testdata/bin/import_test_data core
