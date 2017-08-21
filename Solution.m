%==========================================================================
% Created on Aug 20, 2017  
% Author: Alex Squalli
%==========================================================================
% Solution.m is the main file. 
% "jsonlab" toolbox developed by Qianqian Fang is used to read .json file
% "jsonlab" toolbox inculdes loadjson.m, mergestruct.m, struct2jdata.m, 
% and varargin2struct.m
% www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files
%==========================================================================
clear all;
clc;

% import data from 'webevents.json' file
data = loadjson('webevents.json','SimplifyCell',1) 

% create person_opk_mat matrix to store person_opk data 
m = length(data);
person_opk_mat = cell(1,m); 
[person_opk_mat{:}] = data.person_opk;

% 1. Calculate authenticated and anonymous users who visited the homepage
%=========================================================================
% find null value 
 person_opk_null_mat=cellfun('isempty',person_opk_mat);
 auth_users_indices = find(person_opk_null_mat == 0);
 anony_users_indices = find(person_opk_null_mat == 1);
 
 person_opk_mat(anony_users_indices)={''};
 person_opk_mat2=cell2mat(person_opk_mat');
 
 % creates a frequency table of data  
 table_per_opk = tabulate(person_opk_mat);
 %tabulate(person_opk_mat)
 [search_vp_fq, avg_users ,d_mat] = unique(cell2mat(table_per_opk(:,2)));
 disp('count:')
 disp([search_vp_fq, avg_users])
 
 %tot_auth_users = length(auth_users_indices);
 tot_auth_users = length(unique(person_opk_mat2, 'rows'));
 tot_anony_users = length(anony_users_indices);
 tot_users = tot_auth_users + tot_anony_users;
 
 % validate tot_users 
 isequal(tot_users, m);

 fprintf( '\nAnswer Q1:----------------------------------------------------\n')
 fprintf( '%d total users visited the homepage.\n',tot_users) 
 fprintf( '- %d authenticated users visited the homepage.\n',tot_auth_users) 
 fprintf( '- %d anonymous users visited the homepage.\n', tot_anony_users) 

% 2. Calculate the percentage of authenticated users who go on to visit a 
% search page within 30 minutes 
%=========================================================================
% find search pageviews
page_category_mat = cell(1,m); 
[page_category_mat{:}] = data.page_category;

cellfind = @(str_x)(@(cell_contents)(strcmp(str_x,cell_contents)));
logical_cells_mat = cellfun(cellfind('search'),page_category_mat);

% authenticated users who visited the homepage
search_vp_mat_indices = find(logical_cells_mat == 1);
tot_search_vp_users = length(search_vp_mat_indices); 

[tf, auth_search_indices] = ismember(search_vp_mat_indices, auth_users_indices);
%auth_search_indices2 = find(search_vp_mat_indices == auth_users_indices)
auth_search_ind3 = find(auth_search_indices ~= 0);
tot_auth_search_users = length(auth_search_ind3);
per_auth_search_users = tot_auth_search_users/tot_users *100;
fprintf( '\nAnswer Q2:-----------------------------------------------------\n')
fprintf( '%d total authenticated users visited a search page.\n',tot_auth_search_users) 
fprintf( '%0.2f%% authenticated users visited a search page\n',per_auth_search_users) 

% convert ts to date
% ts = 1493642029744;% ts = ts_mat2(end)
% datestr(datevec(ts/60/60/24/1000) + [1970 0 0 0 0 0])

%ts_mat = data.ts
ts_mat = cell(1,m); 
[ts_mat{:}] = data.ts;
ts_mat2 = cell2mat(ts_mat);
t0 = min(ts_mat2);
ts_date_mat =[];
    for i = 1:length(ts_mat2)
        ts_date_mat = datestr(datevec(ts_mat2(i)/60/60/24/1000) + [1970 0 0 0 0 0]);
        %ts_date_mat(i) = ts_date_mat;
    end
    disp(' ')
    disp(ts_date_mat)
      
% 3. What is the average number of search pages that a user visits?
%=========================================================================
% find search pageviews
search_vp_users_mat =  person_opk_mat(search_vp_mat_indices');
table_search_vp = tabulate(search_vp_users_mat);

[search_vp_fq2, avg_users2 ,d_mat2] = unique(cell2mat(table_search_vp(:,2)));
disp('count:') 
disp([search_vp_fq2, avg_users2])
%hist(cell2mat(table_search_vp(:,2))) 
%pareto(cell2mat(table_search_vp(:,2)))
fprintf( '\nAnswer Q3:---------------------------------------------------\n')
fprintf( 'The average number of search pages that a user visits after visiting the homepage is %d.\n\n',search_vp_fq(1)) 

% 4. Which UTM source is best at generating users which visit both a homepage 
% and then a search page?
%==========================================================================
% find utm_source
utm_source_mat = cell(1,m); 
[utm_source_mat{:}] = data.utm_source;
utm_source_null_mat=cellfun('isempty',utm_source_mat);
utm_source_null_indices = find(utm_source_null_mat == 1);
utm_source_mat(utm_source_null_indices)={''};
utm_source_mat2=cell2mat(utm_source_mat');

fprintf( '\nAnswer Q4:---------------------------------------------------\n')
fprintf( 'the best UTM source at generating users who visited a homepage and then a search page.\n\n') 

table_utm_source = tabulate(utm_source_mat2);
tabulate(utm_source_mat2)
%[search_vp_fq3, avg_users3 ,d_mat3] = unique(cell2mat(table_search_vp(:,2)))
[search_vp_fq3, avg_users3 ,d_mat3] = unique(cell2mat(table_utm_source(:,2)));
disp(' ')
fprintf('count:')
disp([search_vp_fq3, avg_users3])

fprintf( '\nAnswer Q5:---------------------------------------------------\n')
fprintf( '\nPlease refer to the word document.\n\n') 

% % distinct_id
% %========================
% dist_id_mat = cell(1,m); 
% [dist_id_mat{:}] = data.distinct_id;
% table_dist_id = tabulate(dist_id_mat)
% [search_vp_fq, avg_users ,d_mat] = unique(cell2mat(table_dist_id(:,2)))
