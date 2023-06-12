//data type
//unsigned
bit b1;
bit b32[32];
int unsigned b32;
//signed
int b32_s;
byte b8;
shortint b16;
longint b64;
real b64;
//have X and Z
integer b64_s;
time b64_us;

//array is like C
int a[4] = '{1,2,3,4};
int b[3];
int c[2][3];
b[0:1] = '{1,2};

//bit [][] a vs bit [] a []
bit [3:0] a[3];
bit [3] [4] b;
//difference
@(b[0] or b[1] or b[2])
@(a)


//internal function
$size(b)
foreach

c = '{'{1,2,3},'{4,5,6}};
initial begin
    foreach(c[i,j])
        $display("c[%0d][%0d] = %0d",i,j,c[i][j]);
end

//allocate memory, dynamic array
int a[];
a = new[4];
a.delete();

//sparse memory allocation --- associative array
initial begin
    bit [63:0] assoc[bit[63:0]];
    bit idx = 1;
    //initialize
    repeat (64) begin
        assoc[idx] = idx;
        idx = idx << 1;
    end
    //iteration
    foreach(assoc[i])
        $display("assoc[%0d] = %0d",i,assoc[i]);

    assoc.first(idx);//C++: idx = assoc_it.begin();
    assoc.next(idx);
end

//hash array
int  hash[string];
int min,max;

hash["max"] = 100;
hash["min"] = 0;


//min, max, unique .min(); ...

//with   return a queue
int a[4] = '{9,8,1,3,4,4};
int tq[$];
tq=a.find with(item>3);
tq=a.find_index with(item>3) with (item<8);
tq=a.find_last with(item==4);

int count,total;
count = a.sum with (item>7);
total = a.sum with ((item>7)*item);
total = a.sum with (item<8?item:0);

//sort
a.sort();
a.reverse();

int h;
bit [7:0] j[4] = '{8'ha, 8'hb, 8'hc, 8'hd};
bit [7:0] g;
bit [7:0] a,b,c,d;
h = {>>{j}};
g = {>>{j}};
{>>{a,b,c,d}} = j;
//structure s = '{16'haaaa,8'hbb,8'hcc};
byte b[];
b = {>>{s}};//{aa aa bb cc}