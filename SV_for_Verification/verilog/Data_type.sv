//two direction queue
q[$]  = {0,2,5};
q2[$] = {3,4}; 
initial begin
    q.insert(1,1); //0,1,2,5
    q.insert(3,q2);//0-5
    q.delete(0);   //1-5   
    q.push_front();
    q.pop_back;
    q = {q[0],1,1[1:$]};
    q = {};//delete all
end

//string
string s;
s = "IEEE"
s.len()
s.getc(0) // I

//time
time tdelay=800ps;
# tdelay;

