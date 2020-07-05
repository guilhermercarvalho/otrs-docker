su - otrs -c "/opt/otrs/bin/otrs.Daemon.pl start"; \
for imodules in GeneralCatalog ITSMCore \
ITSMChangeManagement \
ITSMConfigurationManagement \
ITSMIncidentProblemManagement \
ITSMServiceLevelManagement ImportExport; \
do wget -q ftp://ftp.otrs.org/pub/otrs/itsm/packages6/${imodules}-6.0.23.opm; \
su - otrs -c "/opt/otrs/bin/otrs.Console.pl Admin::Package::Install /${imodules}-6.0.23.opm"; \
rm /${imodules}-6.0.23.opm; done