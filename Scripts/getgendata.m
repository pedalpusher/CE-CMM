function supply = getgendata()

%% Get raw data
path='/Raw Data/uk_generation_capacity.xlsx';
[~,~,r]=xlsread(path,'Sheet1');

%% Organise and reformat data

%Set technology catergories
techs= {'Coal','OCGT','CCGT','Oil','Nuclear','WindOn','WindOFF',...
        'Hydro','Biomass','CHP','SolarWaveTidal'};%,'Interconnector''PumpedStorage',
%Reference technology calls
techname={{'coal','coal/oil','Gas/Coal/Oil','coal/biomass','coal/biomass ',...
          'coal/biomass/gas/waste derived fuel','coal/oil','Coal'};...
          {'OCGT','gas oil','gas turbine','mines gas','gas/oil','landfill gas','mines gas'};...
          {'CCGT','Gas','gas'};...
          {'oil','diesel','light oil','gas oil/kerosene'};...
          {'nuclear'};...
          {'wind','wind  ','wind   ','Wind'};...
          {'Wind (offshore)','wind (offshore)'};{'hydro'};...
          {'meat & bone meal','poultry litter','rapeseed oil','straw/gas','various fuels',...
          'waste','biomass','AWDF ','Biomass','biomass and waste'};...
          {'Gas CHP','Gas/Gas oil CHP','gas CHP'};...
          {'solar photovoltaics and wave/tidal'}};%;...{'interconnector'};{'hydro/ pumped storage','pumped storage'};...

%Create supply struct
for i=1:1:length(techs)
    supply.(techs{i})=[];
end

for i=1:1:length(techs)
    for k=2:1:458
        if max(strcmp(r{k,3},techname{i}))
            tech=r{k,3};
            cap=r{k,4};
            startyear=r(k,5);
            location=r{k,6};
            if ~isnan(r{k,7})
                endyear=r{k,7};
            else
                endyear=2050;
            end
            if ~isnan(r{k,8})
                note=(r{k,8});
            else
                note=[];
            end
            companyname=r{k,1};
            plantname=r{k,2};
            pname=r{k,2};
            if ~isnan(pname)
                for j=length(pname):-1:1
                    if strcmp(pname(j),' ')
                        pname(j)=[];
                    end
                end
                for j=length(pname):-1:1
                    if strcmp(pname(j),'&')
                        pname(j)=[];
                    end
                end
                for j=length(pname):-1:1
                    if strcmp(pname(j),'.')
                        pname(j)=[];
                    end
                end
                 for j=length(pname):-1:1
                    if strcmp(pname(j),'(')
                        pname(j)=[];
                    end
                 end
                 for j=length(pname):-1:1
                    if strcmp(pname(j),')')
                        pname(j)=[];
                    end
                 end
                 for j=length(pname):-1:1
                    if strcmp(pname(j),'-')
                        pname(j)=[];
                    end
                 end
                 for j=length(pname):-1:1
                    if strcmp(pname(j),'�')
                        pname(j)=[];
                    end
                 end
                 for j=length(pname):-1:1
                    if strcmp(pname(j),',')
                        pname(j)=[];
                    end
                 end
                 for j=length(pname):-1:1
                    if strcmp(pname(j),'''')
                        pname(j)=[];
                    end
                 end
            end
            supply.(techs{i}).(pname)=struct('Name',plantname,'Owner',...
            companyname,'Capacity',cap,'StartYear',startyear,'EndYear',endyear',...
            'Location',location,'Technology',tech,'Note',note);
        end
    end
end

%% Import technological and financial specifications

techpath='\Raw Data\technology_database.xlsx';
[~,~,r2]=xlsread(techpath,'Comparison');
[~,~,r3]=xlsread(techpath,'Availability');

techs=fieldnames(supply);
for a=1:1:length(techs)
    eff.(techs{a})(1)=r2{23,2};
end

%% Assign age factor to each plant

techs=fieldnames(supply);
for a=1:1:length(techs)
    plants=fieldnames(supply.(techs{a}));
    for b=1:1:length(plants)
        yrs{a}(b)=supply.(techs{a}).(plants{b}).StartYear;
    end
    for b=1:1:length(plants)
        range=max(yrs{a})-min(yrs{a});
        agefactor{a}(b)=( yrs{a}(b) - min(yrs{a}) )/range;
    end
end

techs=fieldnames(supply);
for a=1:1:length(techs)
    plants=fieldnames(supply.(tech{a}));
    for b=1:1:length(plants)
        supply.(techs{a}).(plants{b}).Efficency=
    end
end        