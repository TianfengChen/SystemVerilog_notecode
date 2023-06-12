//open file
//https://www.runoob.com/w3cnote/verilog2-file.html

int hash[string];
integer file;
integer err,str;
file = $fopen("file.txt",r);
file_ = $fopen("file_.txt",w+);
err = $ferror(file);
while(!$feof(file)) begin
    $fscanf(file,"%s's age is %d",name,age);
    hash[name] = age;
    $fdisplay(file_, "age of %s is %d", name, age);//write to file
    $fmonitor(file_,"age of %s is %d", name, age);//write when variable change
end
$fclose(file);