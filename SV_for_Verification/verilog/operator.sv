initial begin
    //<<
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
    
    //
end

    
