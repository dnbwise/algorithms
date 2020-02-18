% Computes the strength of arguments as defined in Sloman, 1993.
% Results are output to 'results.txt' in the working directory.
%
% fbim(dataset, premise, category)
%
% <string>     dataset: the name of the dataset.
%
% <cell-array> premise: one or two premises.
% 
% <string>     category: an optional conclusion category, which is made up of elements 
%					     that have a feature (e.g. 'is a bird') in dataset.
%
% usage: fbim('data_animals_cogsci', {'Eagle', 'Owl'}, 'is a bird')
%        fbim('data_animals_cogsci', {'Eagle', 'Owl'}, '')
%		 fbim('data_animals_cogsci', {'Eagle'}, 'is a bird')
%        fbim('data_animals_cogsci', {'Eagle'}, '')

function fbim(dataset, premise, category)

    load(dataset);

    file = fopen('results.txt', 'a+');
    fprintf(file, '----------\n');
    fprintf(file, 'tuple = \n');
    
    premiseObs = [];    
    
    for i=1:length(premise)
        premiseObs(i) = strmatch(premise{i}, labels.o);
        fprintf(file, ' %s\n', premise{i});    
        fprintf(file, '\n');
    end
    
    missingObs = setxor(premiseObs, 1:size(data,1));    
    conclusionObs = data(missingObs,:);
    premiseObs = data(premiseObs,:);
    
    if(~isempty(category))
        superCat = hasFeature(dataset, category);
        superCatObs = [];
        superCatFeatures = zeros(1,size(data,2));
        for i=1:length(superCat)
            superCatObs(i) = strmatch(superCat{i}, labels.o);
            % the superordiate category is a vector encoding the
            % features of all of the objects under that category.
            superCatFeatures = superCatFeatures | data(superCatObs(i),:);
        end
        
        conclusionObs(end+1,:) = superCatFeatures;
        missingObs(end+1) = size(data,1) + 1;
        labels.o{end+1} = category;
    end      
    
    % calculate strength for each conclusion
    for i=1:size(conclusionObs,1)
        
        if(length(premise) == 2)
            
            strength = (dot(premiseObs(1,:), conclusionObs(i,:)) +  ...
                (1 - (dot(premiseObs(1,:), premiseObs(2,:)) / (norm(premiseObs(2,:))^2))) * ...
                (dot(premiseObs(2,:), conclusionObs(i,:)) - sum(premiseObs(1,:) & premiseObs(2,:) & conclusionObs(i,:)))) / ...
                (norm(conclusionObs(i,:))^2);

                fprintf(file, '%s %0.2f\n', labels.o{missingObs(i)}, strength);
        else
            
            strength = dot(premiseObs(1,:),conclusionObs(i,:)) / (norm(conclusionObs(i,:))^2);

            fprintf(file, '%s %0.2f\n', labels.o{missingObs(i)}, strength);
            
        end
    end
    
    fclose(file);
    
end