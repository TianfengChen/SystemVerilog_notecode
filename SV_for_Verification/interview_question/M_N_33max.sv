class rand_mat;
    int M;
    int N;
    rand int a[][];
    function void new(int M, int N)
        this.M = M;
        this.N = N;
        a = new int[M][N];
    endfunction

    constraint c{
        for(int i=1; i<M-1; i++){
            for(int j=1; j<N-1; j++){
                a[i][j] == a[i-1][j] + a[i+1][j] + a[i][j-1] + a[i][j+1];
            }
        }
    }