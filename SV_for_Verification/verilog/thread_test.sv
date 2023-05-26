program automatic test;
    initial begin
        for(int j = 0; j < 3; j++)
            fork
                automatic int k = j;
                $write(k);
            join
        $display("\nok");
    end
endprogram