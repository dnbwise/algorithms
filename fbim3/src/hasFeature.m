% Returns a <cell-array> of <string> elements, where element has feature in
% dataset.
%
% hasFeature(dataset, feature)
%
% <string> dataset: the name of the dataset.
%
% <string> feature: the feature of interest.
%
% usage: hasFeature('data_animals_cogsci', 'is a bird')

function [objects] = hasFeature(dataset, feature)

    load(dataset);
    
    objects = {};
    
    for i=1:size(data,1)
       
       features = labels.f(data(i,:)==1);      
       
       for j=1:length(features)
           
        if(strmatch(features(j),feature))
           objects{end+1} = labels.o(i);
        end

       end
       
    end
    
end
        
        