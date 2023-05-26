//open file
int hash[string];

file = $fopen(".txt",r);
while(!$feof(file)) begin
    $fscanf(file,"%s %d",name,age);
    hash[name] = age;
end