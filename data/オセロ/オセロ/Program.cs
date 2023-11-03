int g = 11;
string[] qizi = new string[99];
int[] fenshu = new int[65];//用于判断黑白
int flag = 1;
int i = 1;//判断是谁的回合
int hei; int bai;
int l;//扫描的次数表示L
int you = 0;//用于右侧的判定
int zuo = 0;//用于左侧的判定
int zuoshang = 0;
int youxia = 0;
int youshang = 0;
int zuoxia = 0;
int shang =0;
int xia = 0;
int z; //用于转换64与99
int j;
int zongfen;//用于判断游戏的结束跟胜负
int shengfu;//用于判断胜负
int rule;//用于判断是否作弊
int s;//用于判断能否下棋
int zhiqian;//变换之前的摸个颜色的棋子的数量
int zhihou;//  变换之后的某个颜色的棋子的数量
int pass;//用于判断在这个位置能否放棋子
int panding;//用于跳过无法放子的回合·
int heiq;
int baiq;
int end=1;
int baizi=0;int heizi=0;
int w;
int e;
int heijineng;
int baijineng;
int heijineng2=1;
int baijineng2=1;
int turn=0;
heiq = 1;baiq = 1; w = 1;e = 1 ;
heijineng = 1;baijineng = 1;

Console.WriteLine("   数字じゃないものを入力するとバグりますので、入力の時は気をつけてください。");
Console.WriteLine("ルール説明：");
Console.WriteLine("オセロの遊び方に踏まえたものになります");
Console.WriteLine("スペシャルルールとして、挟まれたコマは次のターンに取られてしまいます。");
Console.WriteLine("キーボードで入力します。");
Console.WriteLine("０：パスする　１：スキール発動、二回連続動けます　２：スキール発動、相手のコマを一つ自分のものにすることができます");
Console.WriteLine("(スキールは総計一回しか発動できない)");
Console.WriteLine("10ターン後にスキールを使えます");

Console.WriteLine("９を入力するとゲーム終了となります。");
for (j = 1; j <= 64; j++)
{
    //defen[j] =0;
    fenshu[j] = 0;
}
fenshu[28] = -1;
fenshu[37] = -1;
fenshu[29] = 1;
fenshu[36] = 1;
while (flag == 1)
{
    zhiqian = 0;
    zhihou = 0;
    while (g <= 88)
    {

        qizi[g] = Convert.ToString(g);
        g++;
    }

    g = 11;
    while (g < 89)
        if (g % 10 < 9)
        {
            z = 8 * (g / 10 - 1) + g % 10;
            if (fenshu[z] == 1)
            {
                Console.Write(
                " 黒" //+ qizi[g]
                );
            }
            else if (fenshu[z] == -1)
            {
                Console.Write(
               " 白" //+ qizi[g]
               );

            }
            else
            {
                Console.Write(
                " " + g //+ qizi[g]
                );
            }
            g++;

        }
        else
        {
            Console.WriteLine();
            g = g + 2;
        }//到这为止是写棋子

    if (i % 2 == 1)
    {
        pass = 1;
        Console.WriteLine();
        Console.Write("黒の番です");
        turn++;
        do
        {
            rule = 0;
            hei = Convert.ToInt32(Console.ReadLine());
            if(hei==1||hei==2)
            {
                if (turn<10)
                {
                    Console.WriteLine("10ターンまでにはスキールは使えません、いまは" + turn + "ターンです。");
                    turn--;
                        i++;
                    break;
                }
            }
            if(hei == 0)
            {
                
                break;
            }
            if(hei == 9)
            {
                
            
                    for (j = 1; j <= 64; j++)
                    {
                        if (fenshu[j] == 1)
                        {
                            heizi++;
                        }
                        if (fenshu[j] == -1)
                        {
                            baizi++;
                        }
                    }
                baiq++;
                    Console.WriteLine("黒は" + heizi + "枚");
                    Console.WriteLine("白は" + baizi + "枚");
                    if (heizi > baizi)
                    {

                        Console.WriteLine("黒の勝ち");

                    }
                    else if (baizi > heizi)
                    {
                        Console.WriteLine("白の勝ち");
                    }
                    else
                    {
                        Console.WriteLine("引き分け");
                    }

                    flag = 0;
                
                end = 0;
                break;

            }
            
            if(heijineng == 0)
            {
                heijineng--;
                i--;
            }
            if(hei==2)
            {
                if (heijineng == 1&heijineng2==1)
                    {
                    heijineng2--;
                    while (flag == 1)
                    {
                        if(j==0)
                        {
                            break;
                        }
                        Console.Write("どこの白いコマを黒くしますか？");

                        j = Convert.ToInt32(Console.ReadLine());
                        z = 8 * (j / 10 - 1) + j % 10;
                        if (fenshu[z] == -1)
                        {
                            
                            fenshu[z] = 1;
                            break;
                        }
                        else { Console.Write("白コマの位置を入力してください"); }
                    }
                }
                else { Console.WriteLine("スキールは一回しか使えません"); }
                break;
            }
            if(hei == 1)
            {
                if (heijineng == 1 && heijineng2 == 1)
                {
                    heijineng--;
                    heiq--;
                   
                    Console.WriteLine("スキール発動、これで黒は二回動けます");
                    
                    break;
                }
                else { Console.WriteLine("スキールは一回しか使えません");
                    //if(heijineng2!=0)
                    //{
                    //    heijineng2--;
                    //    i++;
                    //}
                    break;
                }
               
            }
           
            z = 8 * (hei / 10 - 1) + hei % 10;
            //if(q==1)
            //{ break; }
            if (hei / 10 < 1 || hei / 10 > 8 || hei % 10 > 8)
            {
                //if (hei == 9)
                //{ break; }
                //Console.WriteLine(hei);
                Console.Write("ルール違反です、マスに入るようにもう一度入力してください：");
                hei = Convert.ToInt32(Console.ReadLine());
                z = 8 * (hei / 10 - 1) + hei % 10;
                rule = 1;
            }
            else if (fenshu[z] == 1 || fenshu[z] == -1)
            {
                Console.WriteLine("ルール違反です、コマのないマスに入るようにもう一度入力してください：");
                hei = Convert.ToInt32(Console.ReadLine());
                z = 8 * (hei / 10 - 1) + hei % 10;
                rule = 1;
            }
        //} while (rule == 1);
        for (j = 1; j <= 64; j++)
        {
            if (fenshu[j] == -1)
            {
                zhiqian = zhiqian + 1;
            }
        }
            z = 8 * (hei / 10 - 1) + hei % 10;
            fenshu[z] = 1;
            l = 11;
            while (l < 89)
            {
                z = 8 * (l / 10 - 1) + l % 10;

                if (l % 10 < 9)
                {
                    pass = 1;
                    if (fenshu[z] == -1)
                    {

                        z = 8 * (l / 10 - 1) + l % 10;
                        if (fenshu[z] == -1 & z <= 64)
                        {
                           // Console.WriteLine(l);
                            zuo = 0; you = 0; zuoshang = 0; zuoxia = 0; youshang = 0; youxia = 0;
                            shang = 0; xia = 0;
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (z / 8 > 0)//进行上的检查
                            {
                                if (fenshu[z - 8] == -1)
                                { z = z - 8; }
                                else if (fenshu[z - 8] == 1)
                                {
                                    shang = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while ((z - 1) / 8 < 7)//进行下的检查
                            {
                                if (fenshu[z + 8] == -1)
                                { z = z + 8; }
                                else if (fenshu[z + 8] == 1)
                                {
                                    xia = 1;
                                    z = 64;
                                }
                                else { z = 64; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (7 - (z % 8) < 7)//进行右侧的检查
                            {
                                if (fenshu[z + 1] == -1)
                                { z++; }
                                else if (fenshu[z + 1] == 1)
                                {
                                    you = 1;
                                    z = 8;
                                }
                                else { z = 8; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (7 - ((z - 1) % 8) < 7)//进行左侧的检查
                            {
                                if (fenshu[z - 1] == -1)
                                { z--; }
                                else if (fenshu[z - 1] == 1)
                                {
                                    zuo = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            // z/8 要往左上角进行判断的次数
                            while ((z - 1) / 8 > 0 & (z - 1) % 8 > 0)//进行左上的检查
                            {
                                if (fenshu[z - 9] == -1)
                                { z = z - 9; }
                                else if (fenshu[z - 9] == 1)
                                {
                                    zuoshang = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            // z/8 要往左上角进行判断的次数
                            while (7 - (z / 8) > 0 & z % 8 > 0)//进行右下的检查
                            {
                                if (fenshu[z + 9] == -1)
                                { z = z + 9; }
                                else if (fenshu[z + 9] == 1)
                                {
                                    youxia = 1;
                                    z = 64;
                                }
                                else { z = 64; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;

                            while (z / 8 > 0 & z % 8 > 0)//进行右上的检查
                            {
                                if (fenshu[z - 7] == -1)
                                { z = z - 7; }
                                else if (fenshu[z - 7] == 1)
                                {
                                    youshang = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (7 - (z / 8) > 0 & (z - 1) % 8 > 0)//进行左下的检查
                            {
                                if (fenshu[z + 7] == -1)
                                { z = z + 7; }
                                else if (fenshu[z + 7] == 1)
                                {
                                    zuoxia = 1;
                                    z = 64;
                                }
                                else { z = 64; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            if (shang == 1 & xia == 1)
                            {
                               
                                rule = 0;
                                pass = 0;
                                break;
                            }
                            else if (zuoshang == 1 & youxia == 1)
                            {
                                
                                rule = 0;
                                pass = 0;
                                break;
                            }
                            else if (youshang == 1 & zuoxia == 1)
                            {
                               
                                rule = 0;
                                pass = 0;
                                break;
                            }
                            else if (zuo == 1&you==1)
                            {
                                rule = 0;
                                pass = 0;
                                break;

                            }
                            else{ rule = 1;pass = 1; }
                        }
                        


                    }
                    l++;
                }
                else {
                    l = l + 2;
                   
                        }
            }
            if(pass==1)
            {
                Console.WriteLine("ルール違反です,少なくとも白いコマを一つ回転させてください");
                z = 8 * (hei / 10 - 1) + hei % 10;
                fenshu[z] = 0;
                rule = 0;
                i--;
            }
         
            
        } while (rule == 1) ;
        if (heiq == 0)
        {
            i++;
            heiq--;
        }
        i++;
       
       


    } else
    {
        pass = 1;
        Console.WriteLine();
        Console.Write("白の番です");
        turn++;

        do
        {
            //Console.WriteLine();
            //Console.Write("白の番です");

            bai = Convert.ToInt32(Console.ReadLine());

            if (bai == 1 || bai == 2)
            {
                if (turn < 10)
                {
                    Console.WriteLine("10ターンまでにはスキールは使えません、いまは" + turn + "ターンです。");
                    turn--;
                    i++;
                    break;
                }
            }
            if (bai == 0)
            {

                break;
            }
            if (bai == 2)
            {
                if (baijineng == 1 & baijineng2 == 1)
                {
                    baijineng2--;
                    while (flag == 1)
                    {
                        if (j == 0)
                        {
                            break;
                        }
                        Console.Write("どこの黒いコマを白くしますか？");

                        j = Convert.ToInt32(Console.ReadLine());
                        z = 8 * (j / 10 - 1) + j % 10;
                        if (fenshu[z] == 1)
                        {
                            
                            fenshu[z] = -1;
                            break;
                        }
                        else { Console.Write("黒コマの位置を入力してください"); }
                    }
                }
                else { Console.WriteLine("スキールは一回しか使えません"); }
                break;
            }
            if (bai == 9)
            {

              
                for (j = 1; j <= 64; j++)
                {
                    if (fenshu[j] == 1)
                    {
                        heizi++;
                    }
                    if (fenshu[j] == -1)
                    {
                        baizi++;
                    }
                }

                Console.WriteLine("黒は" + heizi + "枚");
                Console.WriteLine("白は" + baizi + "枚");
                if (heizi > baizi)
                {

                    Console.WriteLine("黒の勝ち");

                }
                else if (baizi > heizi)
                {
                    Console.WriteLine("白の勝ち");
                }
                else
                {
                    Console.WriteLine("引き分け");
                }

                flag = 0;

                end = 0;
                break;

            }

            if (baijineng == 0)
            {
                baijineng--;
                i--;
            }
            if (bai == 1)
            {
                if (baijineng == 1&baijineng2==1)
                {
                    baijineng--;
                    baiq--;
                    i--;
                    Console.WriteLine("スキール発動、これで白は二回動けます");

                    break;
                }
                else
                {
                    Console.WriteLine("スキールは一回しか使えません");
                    break;
                }

            }

            z = 8 * (bai / 10 - 1) + bai % 10;
            rule = 0;
           
            if (bai / 10 < 1 || bai / 10 > 8 || bai % 10 > 8)
            {
                Console.Write("ルール違反です、マスに入るようにもう一度入力してください：");
                bai = Convert.ToInt32(Console.ReadLine());
                z = 8 * (bai / 10 - 1) + bai % 10;
                rule = 1;
            }
            else if (fenshu[z] == 1 || fenshu[z] == -1)
            {
                Console.WriteLine("ルール違反です、コマのないマスに入るようにもう一度入力してください：");
                bai = Convert.ToInt32(Console.ReadLine());
                z = 8 * (bai / 10 - 1) + bai % 10;
                rule = 1;
            }
            //} while (rule == 1);
            for (j = 1; j <= 64; j++)
            {
                if (fenshu[j] == -1)
                {
                    zhiqian = zhiqian + 1;
                }
            }
           
            z = 8 * (bai / 10 - 1) + bai % 10;
            fenshu[z] = -1;
            l = 11;
            while (l < 89)
            {
                z = 8 * (l / 10 - 1) + l % 10;

                if (l % 10 < 9)
                {
                    pass = 1;
                    if (fenshu[z] == 1)
                    {

                        z = 8 * (l / 10 - 1) + l % 10;
                        if (fenshu[z] == 1 & z <= 64)
                        {
                            
                            zuo = 0; you = 0; zuoshang = 0; zuoxia = 0; youshang = 0; youxia = 0;
                            shang = 0; xia = 0;
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (z / 8 > 0)//进行上的检查
                            {
                                if (fenshu[z - 8] == 1)
                                { z = z - 8; }
                                else if (fenshu[z - 8] == -1)
                                {
                                    shang = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while ((z - 1) / 8 < 7)//进行下的检查
                            {
                                if (fenshu[z + 8] == 1)
                                { z = z + 8; }
                                else if (fenshu[z + 8] == -1)
                                {
                                    xia = 1;
                                    z = 64;
                                }
                                else { z = 64; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (7 - (z % 8) < 7)//进行右侧的检查
                            {
                                if (fenshu[z + 1] == 1)
                                { z++; }
                                else if (fenshu[z + 1] == -1)
                                {
                                    you = 1;
                                    z = 8;
                                }
                                else { z = 8; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (7 - ((z - 1) % 8) < 7)//进行左侧的检查
                            {
                                if (fenshu[z - 1] == 1)
                                { z--; }
                                else if (fenshu[z - 1] == -1)
                                {
                                    zuo = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            // z/8 要往左上角进行判断的次数
                            while ((z - 1) / 8 > 0 & (z - 1) % 8 > 0)//进行左上的检查
                            {
                                if (fenshu[z - 9] == 1)
                                { z = z - 9; }
                                else if (fenshu[z - 9] == -1)
                                {
                                    zuoshang = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            // z/8 要往左上角进行判断的次数
                            while (7 - (z / 8) > 0 & z % 8 > 0)//进行右下的检查
                            {
                                if (fenshu[z + 9] == 1)
                                { z = z + 9; }
                                else if (fenshu[z + 9] == -1)
                                {
                                    youxia = 1;
                                    z = 64;
                                }
                                else { z = 64; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;

                            while (z / 8 > 0 & z % 8 > 0)//进行右上的检查
                            {
                                if (fenshu[z - 7] == 1)
                                { z = z - 7; }
                                else if (fenshu[z - 7] == -1)
                                {
                                    youshang = 1;
                                    z = 1;
                                }
                                else { z = 1; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            while (7 - (z / 8) > 0 & (z - 1) % 8 > 0)//进行左下的检查
                            {
                                if (fenshu[z + 7] == 1)
                                { z = z + 7; }
                                else if (fenshu[z + 7] == -1)
                                {
                                    zuoxia = 1;
                                    z = 64;
                                }
                                else { z = 64; }
                            }
                            z = 8 * (l / 10 - 1) + l % 10;
                            if (shang == 1 & xia == 1)
                            {
                               
                                rule = 0;
                                pass = 0;
                                break;
                            }
                            else if (zuoshang == 1 & youxia == 1)
                            {
                             
                                rule = 0;
                                pass = 0;
                                break;
                            }
                            else if (youshang == 1 & zuoxia == 1)
                            {
                              
                                rule = 0;
                                pass = 0;
                                break;
                            }
                            else if (zuo == 1 & you == 1)
                            {
                                rule = 0;
                                pass = 0;
                                break;

                            }
                            else { rule = 1; pass = 1; }
                        }



                    }
                    l++;
                }
                else
                {
                    l = l + 2;

                }
            }
            if (pass == 1)
            {
                Console.WriteLine("ルール違反です,少なくとも黒いコマを一つ回転させてください");
                z = 8 * (bai / 10 - 1) + bai % 10;
                fenshu[z] = 0;
                rule = 0;
                i--;
            }
        } while (rule == 1);
     
        i++;
        
        //Console.WriteLine(baijineng);
    }

 
    l = 11;
    while (l < 89)
    {
        if (l % 10 < 9)
        {
            zuo = 0; you = 0; zuoshang = 0; zuoxia = 0; youshang = 0; youxia = 0;
            shang = 0;xia =0;
            z = 8 * (l / 10 - 1) + l % 10;
            
            if (fenshu[z] == 1 & z <= 64)
            {
                z = 8 * (l / 10 - 1) + l % 10;
                while (z/8>0)//进行上的检查
                {
                    if (fenshu[z - 8] == 1)
                    { z=z-8; }
                    else if (fenshu[z -8] == -1)
                    {
                        shang = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while ((z-1) / 8 <7)//进行下的检查
                {
                    if (fenshu[z + 8] == 1)
                    { z = z + 8; }
                    else if (fenshu[z + 8] == -1)
                    {
                       xia = 1;
                        z = 64;
                    }
                    else { z = 64; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while (7 - (z % 8) < 7)//进行右侧的检查
                {
                    if (fenshu[z + 1] == 1)
                    { z++; }
                    else if (fenshu[z + 1] == -1)
                    {
                        you = 1;
                        z = 8;
                    }
                    else { z = 8; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while (7 - ((z - 1) % 8) < 7)//进行左侧的检查
                {
                    if (fenshu[z - 1] == 1)
                    { z--; }
                    else if (fenshu[z - 1] == -1)
                    { 
                        zuo = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                // z/8 要往左上角进行判断的次数
                while ((z-1) / 8 > 0 & (z - 1) % 8 > 0)//进行左上的检查
                {
                    if (fenshu[z - 9] == 1)
                    { z = z - 9; }
                    else if (fenshu[z - 9] == -1)
                    { 
                        zuoshang = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                
                while (7 - (z / 8) > 0 & z % 8 > 0)//进行右下的检查
                {
                    if (fenshu[z + 9] == 1)
                    { z = z + 9; }
                    else if (fenshu[z + 9] == -1)
                    { 
                        youxia = 1;
                        z = 64;
                    }
                    else { z = 64; }
                }
                z = 8 * (l / 10 - 1) + l % 10;

                while (z / 8 > 0 & z % 8 > 0)//进行右上的检查
                {
                    if (fenshu[z - 7] == 1)
                    { z = z - 7; }
                    else if (fenshu[z - 7] == -1)
                    { 
                        youshang = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while (7 - (z / 8) > 0 & (z - 1) % 8 > 0)//进行左下的检查
                {
                    if (fenshu[z + 7] == 1)
                    { z = z + 7; }
                    else if (fenshu[z + 7] == -1)
                    {
                        zuoxia = 1;
                        z = 64;
                    }
                    else { z = 64; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                //Console.WriteLine("baiq1"+baiq);
                //if (baiq == -2)
                //{
                //    i++;
                //    baiq--;
                //    break;
                //}
                //if (baiq == 0)
                //{
                //    i++;
                //    baiq--;
                //    break;
                //}

                if (baijineng == -1)
                {
                    if (i % 2 != 1)
                    { 
                    i++;
                       
                    }

                    //Console.WriteLine("i" + i);
                }
                    if (i % 2 == 1)
                {
                   
                    if (baijineng==-1)
                    {
                        i++;
                        baijineng--;
                    }
                  
                    
                

                if (zuo == 1 & you == 1) //|| zuoshang == 1 & youxia == 1 || zuoxia == 1 & youshang == 1)
                    {
                        fenshu[z] = -1;
                        //  qizi[g] = "白";
                    }
                    else if (zuoshang == 1 & youxia == 1)
                    {
                        fenshu[z] = -1;
                    }
                    else if (zuoxia == 1 & youshang == 1)
                    {
                        fenshu[z] = -1;
                    }
                    else if (shang == 1 & xia == 1)
                    {
                        fenshu[z] = -1;
                    }
                    else { }

                }
                if (baijineng == -1)
                {
                    i++;
                    baijineng--;
                }

            }
            else if (fenshu[z] == -1 & z <= 64)
            {
               
                if (heiq == -3)
                {
                    i++;
                    heiq--;
                }
                if (heiq == -1)
                {
                    i++;
                    heiq--;
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while (z / 8 > 0)//进行上的检查
                {
                    if (fenshu[z - 8] == -1)
                    { z = z - 8; }
                    else if (fenshu[z - 8] == 1)
                    {
                        shang = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while ((z - 1) / 8 < 7)//进行下的检查
                {
                    if (fenshu[z + 8] == -1)
                    { z = z + 8; }
                    else if (fenshu[z + 8] == 1)
                    {
                        xia = 1;
                        z = 64;
                    }
                    else { z = 64; }
                }
                    z = 8 * (l / 10 - 1) + l % 10;
                while (7 - (z % 8) < 7)//进行右侧的检查
                {
                    if (fenshu[z + 1] == -1)
                    { z++; }
                    else if (fenshu[z + 1] == 1)
                    { 
                        you = 1;
                        z = 8;
                    }
                    else { z = 8; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while (7 - ((z - 1) % 8) < 7)//进行左侧的检查
                {
                    if (fenshu[z - 1] == -1)
                    { z--; }
                    else if (fenshu[z - 1] == 1)
                    { 
                        zuo = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                // z/8 要往左上角进行判断的次数
                while ((z-1) / 8 > 0 & (z - 1) % 8 > 0)//进行左上的检查
                {
                    if (fenshu[z - 9] == -1)
                    { z = z - 9; }
                    else if (fenshu[z - 9] == 1)
                    {
                        zuoshang = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                // z/8 要往左上角进行判断的次数
                while (7 - (z / 8) > 0 & z % 8 > 0)//进行右下的检查
                {
                    if (fenshu[z + 9] == -1)
                    { z = z + 9; }
                    else if (fenshu[z + 9] == 1)
                    { 
                        youxia = 1;
                        z = 64;
                    }
                    else { z = 64; }
                }
                z = 8 * (l / 10 - 1) + l % 10;

                while (z / 8 > 0 & z % 8 > 0)//进行右上的检查
                {
                    if (fenshu[z - 7] == -1)
                    { z = z - 7; }
                    else if (fenshu[z - 7] == 1)
                    {
                        youshang = 1;
                        z = 1;
                    }
                    else { z = 1; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                while (7 - (z / 8) > 0 & (z - 1) % 8 > 0)//进行左下的检查
                {
                    if (fenshu[z + 7] == -1)
                    { z = z + 7; }
                    else if (fenshu[z + 7] == 1)
                    {
                        zuoxia = 1;
                        z = 64;
                    }
                    else { z = 64; }
                }
                z = 8 * (l / 10 - 1) + l % 10;
                if (i % 2 == 0)
                {
                    if (zuo == 1 & you == 1) //|| zuoshang == 1 & youxia == 1 || zuoxia == 1 & youshang == 1)
                    {
                        fenshu[z] = 1;
                        //  qizi[g] = "白";
                    }
                    else if (zuoshang == 1 & youxia == 1)
                    {
                        fenshu[z] = 1;
                    }
                    else if (zuoxia == 1 & youshang == 1)
                    {
                        fenshu[z] = 1;
                    }
                    else if (shang == 1 & xia == 1)
                    {
                        fenshu[z] = 1;
                    }
                    else { }
                }
            }
                l++;
        }
        else { l = l + 2; }
    }
    //Console.WriteLine("baiq2" + baiq);
    if (heiq == -4)
    {
        i--;
        heiq--;
    }
    if (heiq == -2)
    {
        i--;
        heiq--;
    }
    //if (baiq == -3)
    //{
    //    i--;
    //    baiq--;
    //}
    //if (baiq == -1)
    //{
    //    i--;
    //    baiq--;
    //}
    zongfen = 1;
    shengfu = 0;
    for(j = 1; j <= 64; j++)
    {
        zongfen = zongfen * fenshu[j];
        shengfu = shengfu + fenshu[j];
    }
    if (zongfen == 1||zongfen ==-1)
    {
        g = 11;
        while (g < 89)
            if (g % 10 < 9)
            {
                z = 8 * (g / 10 - 1) + g % 10;
                if (fenshu[z] == 1)
                {
                    Console.Write(
                    " 黒" //+ qizi[g]
                    );
                }
                else if (fenshu[z] == -1)
                {
                    Console.Write(
                   " 白" //+ qizi[g]
                   );

                }
                else
                {
                    Console.Write(
                    " " + g //+ qizi[g]
                    );
                }
                g++;

            }
            else { g = g + 2; }
        
        
    }

}