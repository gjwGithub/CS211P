function [files] = loadFiles(path)
    fileDir = dir(path);
    files = cell(1, length(fileDir) - 2);
    index = 1;
    for i = 1:length(fileDir)
        if ~strcmp(fileDir(i).name, '.') && ~strcmp(fileDir(i).name, '..')
            files{1, index} = [path fileDir(i).name];
            index = index + 1;
        end
    end
end

