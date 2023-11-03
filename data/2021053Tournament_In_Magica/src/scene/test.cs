using Charamaker2;
using Charamaker2.Character;
using Charamaker2.input;
using Charamaker2.Shapes;
using GameSet1;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using THE_Tournament.relic;
using THE_Tournament.waza;
using THE_Tournament.wepon;

namespace THE_Tournament.scene
{
    abstract class battlebase : Scene
    {
        protected EntityManager em;
        public battlebase(SceneManager sm, List<player> p, List<player> e) : base(sm)
        {

            mes = p;
            hes = e;
        }
        protected List<player> mes, hes;
        protected player me { get { return mes[0]; }set { mes[0] = value; } }
        protected player he{get{return hes[0];} set { mes[0] = value; } }
        
        protected float WW, HH;
        protected override void onend()
        {
            base.onend();
            foreach (var a in mes) a.remove();
            foreach (var a in hes) a.remove();
        }
        protected override void onstart()
        {
            base.onstart();
            em = new EntityManager(hyo);
            tokei.resethyoji(hyo);
            tokei.scalechange(0.7f);

            float width = 1024;//両サイド
            float Height = 1024;//普通に高さ
            int W = 2, H = 1;
            WW = W * 1024;
            HH = 1024 * H;

            {

                var rec = new ABrecipie(new List<string> { "", "body" }, new List<Shape> { new Circle(0, 0, 0, 0, 0), new Circle(0, 0, 0, 0, 0) });

                mehp = 0;
                foreach (var a in mes)
                {
                    a.c.settxy(WW / 4, -HH / 2);
                    a.setab(true);
                    a.tag.Clear();
                    foreach (var b in hes)
                    {
                        a.tag.Add(b);
                    }
                    a.add(em);
                    mehp += a.s.hel;
                }
                hehp = 0;
                foreach (var a in hes)
                {
                    a.c.settxy(-WW / 4, -HH / 2);
                    a.setab(true);
                    a.tag.Clear();
                    foreach (var b in mes)
                    {
                        a.tag.Add(b);
                    }
                    a.add(em);
                    hehp += a.s.hel;
                }

                hyo.camx = me.c.gettx() - hyo.ww / 2;
                hyo.camy = me.c.getty() - hyo.wh / 2;



                //  new shapedraw().add(me);
                //  new shapedraw().add(he);

            }
            for (int i = -W / 2-1; i < W / 2+1; i++)
            {
                {
                    var jimen = new Entity(character.onepicturechara("tikei\\sougen\\ground", width * 1.2f, 0, false, 0.5f, 0)
                        , new ABrecipie(new List<string> { "" }, new List<Shape> { new Rectangle(0, 0) })
                        , new buturiinfo(-1, 1, 1, 1, atag: new List<string> { "tikei" })); ;

                    jimen.c.settxy(width * (0.5f + i), 0);
                    jimen.add(em);
                }

                {
                    var jimen = new Entity(character.onepicturechara("tikei\\sougen\\ground", width * 1.2f, 0, false, 0.5f, 1)
                        , new ABrecipie(new List<string> { "" }, new List<Shape> { new Rectangle(0, 0) })
                        , new buturiinfo(-1, 1, 1, 1, atag: new List<string> { "tikei" })); ;

                    jimen.c.settxy(width * (0.5f + i), -Height * H);
                    jimen.add(em);
                }
            }
            for (int i = 0; i < H; i++)
            {
                {
                    var jimen = new Entity(character.onepicturechara("tikei\\sougen\\wall", Height * 1.2f, 0, true, 1, 0.5f)
                        , new ABrecipie(new List<string> { "" }, new List<Shape> { new Rectangle(0, 0) })
                        , new buturiinfo(-1, 1, 1, 1, atag: new List<string> { "tikei" })); ;

                    jimen.c.settxy(width * (-W / 2), -Height * (i + 0.5f));
                    jimen.add(em);
                }

                {
                    var jimen = new Entity(character.onepicturechara("tikei\\sougen\\wall", Height * 1.2f, 0, true, 0, 0.5f)
                        , new ABrecipie(new List<string> { "" }, new List<Shape> { new Rectangle(0, 0) })
                        , new buturiinfo(-1, 1, 1, 1, atag: new List<string> { "tikei" })); ;

                    jimen.c.settxy(width * (W / 2), -Height * (i + 0.5f));
                    jimen.add(em);
                }
            }
            float si = WW / 70;
            var aan = new List<haikeiseiser>();
            aan.Add(new GameSet1.haikeiseiser("effects\\firebit", si, si *0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            aan.Add(new GameSet1.haikeiseiser("effects\\icebit", si, si * 0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            aan.Add(new GameSet1.haikeiseiser("effects\\windbit", si, si * 0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            aan.Add(new GameSet1.haikeiseiser("effects\\earthbit", si, si * 0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            aan.Add(new GameSet1.haikeiseiser("effects\\thunderbit", si, si * 0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            aan.Add(new GameSet1.haikeiseiser("effects\\lightbit", si, si * 0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            aan.Add(new GameSet1.haikeiseiser("effects\\darkbit", si, si * 0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            aan.Add(new GameSet1.haikeiseiser("effects\\physicbit", si, si * 0.8f, 0.5f, 0.5f, Math.PI, 0.5f, 0.3f, 0.3f, Math.PI, 0.3f));
            int max = 4;
            for (int i = -1; i <= max; i++)
            {
                haikeiseiser(-HH * i / max, HH * 0.7f / max, -WW * 1.1f, WW * 1.1f, 100, 1, aan);
             }
            haikeiseiser(-HH / 2, HH * 0.7f, -WW * 1.1f, WW * 1.1f, 100, 1, aan);



        }
        static public float getcolR(buturiinfo b)
        {
            if (b.contains("me")) return 1;
            if (b.contains("he")) return 0;

            return 0;

        }
        static public float getcolG(buturiinfo b)
        {
            if (b.contains("me")) return 0;
            if (b.contains("he")) return 0;

            return 0;

        }
        static public float getcolB(buturiinfo b)
        {
            if (b.contains("me")) return 0;
            if (b.contains("he")) return 1;

            return 0;

        }

        protected float mehp;
        protected float hehp;
        character tokei = new character(0, 0, 0, 0, 0, 0, 0
            , new setu("core", 0, 0, new picture(0, 0, 0, 0, 0, 0, 0, 0, false, 0, "def", new Dictionary<string, string> { { "def", "nothing" } })
                , new List<setu>
                {
                new setu("tyo",0,0,new picture(0,0,10000,224,32,16,16,0,false,1,"def",new Dictionary<string, string>{ {"def","effects\\tyosin" } }))
           ,     new setu("tan",0,0,new picture(0,0,10000,128,32,16,16,0,false,1,"def",new Dictionary<string, string>{ {"def","effects\\tansin" } }))

                })

            );
        protected float gogotokei(float cl) 
        {

            {
                tokei.settxy(hyo.ww * 0.5f + hyo.camx, hyo.wh * 0.1f + hyo.camy);

                float metiku =  - mehp;
                foreach (var a in mes) 
                {
                    if (a.onEM)
                    {
                        metiku += a.s.hel;
                    }
                }
                float hetiku =  - hehp;
                foreach (var a in hes)
                {
                    if (a.onEM)
                    {
                        hetiku += a.s.hel;
                    }
                }

                float mesum = 0;
                foreach (var a in mes)
                {
                    mesum += a.s.mhel;
                }
                float hesum = 0;
                foreach (var a in hes)
                {
                    hesum += a.s.mhel;
                }
                cl *= 1 + Math.Max(Math.Min(metiku * 1.5f / mesum, 0), -0.8f);
                cl *= 1 + Math.Max(Math.Min(hetiku * 1.5f / hesum, 0), -0.8f);
                cl = Math.Min(Math.Max(cl * cl, 0.25f), 1);

                mehp += metiku / (30 / ((float)Math.Pow(cl, 0.5f)));
                hehp += hetiku / (30 / ((float)Math.Pow(cl, 0.5f)));

                float si = hyo.ww / 35;
                // message.hutidorin(si / 15, hyo.ww * 0.5f + hyo.camx, hyo.wh * 0.1f + hyo.camy, si, 100, 50, 0, 0, cl.ToString(), 1, 1, 1, hyo: hyo);
                tokei.GetSetu("tan").p.RAD += cl * 0.1f;
                tokei.GetSetu("tyo").p.RAD += cl * 0.1f / 20;
                tokei.addmotion(new Kscalechangeman(cl, "", 1 / hyo.bairitu, 1 / hyo.bairitu));

                tokei.frame(cl);
            }
            return cl;
        }

        public override void frame(inputin i, float cl)
        {
            int semegi = 0;
            foreach (var a in mes) 
            {
                if (a.onEM)
                {
                    foreach (var b in hes)
                    {
                        if (b.onEM)
                        {
                            if (a.c.gettx() < b.c.gettx())
                            {
                                semegi -= 1;
                            }
                            else 
                            {
                                semegi += 1;
                            }
                        }
                    }
                }
            }
            if (semegi == 0) 
            {
                foreach (var a in mes)
                {
                    if (a.onEM)
                    {
                        foreach (var b in hes)
                        {
                            if (b.onEM)
                            {
                                if (a.c.gettx() < b.c.gettx())
                                {
                                    semegi -= 1;
                                }
                                else
                                {
                                    semegi += 1;
                                }
                                break;
                            }
                        }
                    }
                }
            }
            if (semegi<0)
            {
                float size = hyo.ww * 0.05f;
                message.hutidorin(size / 15, hyo.camx + hyo.ww * 0.2f, hyo.camy + hyo.wh * 0.1f, size, 100, 0, 0, 0, Math.Round(mehp).ToString(), getcolR(me.bif), getcolG(me.bif), getcolB(me.bif), false, hyo: hyo);
                message.hutidorin(size / 15, hyo.camx + hyo.ww * 0.8f, hyo.camy + hyo.wh * 0.1f, size, 100, 100, 0, 0, Math.Round(hehp).ToString(), getcolR(he.bif), getcolG(he.bif), getcolB(he.bif), false, hyo: hyo);

            }
            else
            {
                float size = hyo.ww * 0.05f;
                message.hutidorin(size / 15, hyo.camx + hyo.ww * 0.8f, hyo.camy + hyo.wh * 0.1f, size, 100, 100, 0, 0, Math.Round(mehp).ToString(), getcolR(me.bif), getcolG(me.bif), getcolB(me.bif), false, hyo: hyo);
                message.hutidorin(size / 15, hyo.camx + hyo.ww * 0.2f, hyo.camy + hyo.wh * 0.1f, size, 100, 0, 0, 0, Math.Round(hehp).ToString(), getcolR(he.bif), getcolG(he.bif), getcolB(he.bif), false, hyo: hyo);

            }
            //  Console.WriteLine(me.c.gettx()+ " asdaj " + he.c.gettx() + " asklfa " + WW);
            em.frame(cl);

            {
                Rectangle z = new Rectangle(-WW / 2 - 100, -HH - 100, WW + 100, HH + 100, 0);
                foreach (var a in mes)
                {
                    if (!z.onhani(a.c.gettx(), a.c.getty()))
                    {
                        a.c.settxy(z.gettx(), z.getty());
                    }
                }
                foreach (var a in hes)
                {
                    if (!z.onhani(a.c.gettx(), a.c.getty()))
                    {
                        a.c.settxy(z.gettx(), z.getty());
                    }
                }

                //   z.drawshape(hyo, 1, 0, 0, 1, true);
            }

        
            me.UIn(i, hyo, cl);


            baseframe(i, cl);
            cameran333(1);
        }
        protected void baseframe(inputin i,float cl) 
        {
            base.frame(i, cl);
        }
        
        float prew = 1000, preh = 1000;
        float precamx = 0, precamy = 0;
        float hiki = 5f;
        protected void cameran333(float cl)
        {
            float camx = 0;
            float camy = 0;
            float wi = 0;
            float hi = 0;
            foreach(var a in mes)
            {
                wi += a.c.gettx() / mes.Count;
                hi += a.c.getty() / mes.Count;
                camx += (a.c.gettx() - hyo.ww / 2)/mes.Count;
                camy += (a.c.getty() - hyo.wh * 0.6f)/mes.Count;

            }
            foreach (var a in hes)
            {
                wi -= a.c.gettx() / hes.Count;
                hi -= a.c.getty() / hes.Count;
                camx += (a.c.gettx() - hyo.ww / 2) / hes.Count;
                camy += (a.c.getty() - hyo.wh * 0.6f) / hes.Count;

            }

            float hikiki = hiki * (me.c.w + he.c.w + me.c.h + he.c.h);

            wi = Math.Abs(wi) + hikiki;
            hi = Math.Abs(hi) + hikiki;

            prew -= (prew - wi) / (30 * (0.3f + 1/hyo.bairitu));
            preh -= (preh - hi) / (30 * (0.3f + 1/hyo.bairitu));

            {

                double rad = Math.Atan2(camy / 2 - precamy, camx / 2 - precamx);
                double kyo = Math.Sqrt(Math.Pow(camy / 2 - precamy, 2) + Math.Pow(camx / 2 - precamx, 2));

                precamx += (float)(Math.Cos(rad) * kyo / (20 * (0.3f + 1 /hyo.bairitu)));
                precamy += (float)(Math.Sin(rad) * kyo / (20 * (0.3f + 1/ hyo.bairitu)));

                hyo.camx = precamx;
                hyo.camy = precamy;
            }



            hyo.setBairituW(fileman.gasitu * prew);
            var t = hyo.bairitu;
            hyo.setBairituW(fileman.gasitu * preh, true);
            if (t < hyo.bairitu) hyo.bairitu = t;
            if (hyo.bairitu >  2) hyo.bairitu =  2;
        }
    }
    class test : battlebase
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.05f, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("VS", "test")
                , 0, 0, 0, false, kazu: 4));
        }
        public test(SceneManager sm,player p,player e) : base(sm,new List<player> { p }, new List<player> { e })
        {
        }
        protected override void onstart()
        {

            SD.S.setPlayerScript(me);
            SD.savesave<SD>();
            base.onstart();
        }
        public override void end()
        {
            
            if (me.onEM)
            {
                me.fase = SD.S.sin.Money;
                SD.S.sin.enfase();
                var aas = he.c.core.p.nowtex;
                switch (aas)
                {
                    case @"enemy\bogo":
                        next = SD.S.sin.genetreasure(me, sm, new testmap(me, sm), rank.bogo);
                        break;

                    case @"enemy\bubble":
                        next = SD.S.sin.genetreasure(me, sm, new testmap(me, sm), rank.bubble);
                        break;

                    case @"enemy\tim":
                        next = SD.S.sin.genetreasure(me, sm, new testmap(me, sm), rank.tim);
                        break;
                    default:
                        next = new testget(sm, me, rank.bogo, new testmap(me, sm));
                        break;
                }
                
            }
            else 
            {
                SD.S.setPlayerScript(me);
                next = new title(sm);
            }
            base.end();
        }

        float endtimer = 180;
        public override void frame(inputin i, float cl)
        {
            cl=gogotokei(cl);
          
            if (i.ok(Keys.Escape, itype.down))
            {
                new testedit(me, sm, this).start();
            }
          
            if (!me.onEM || !he.onEM) 
            {
                if (endtimer > 0) { endtimer -= cl; }
                else
                {
                    end();
                }
            }
            //  Console.WriteLine(me.c.gettx()+ " asdaj " + he.c.gettx() + " asklfa " + WW);
            base.frame(i,cl);


            
        }
    }
    class testedit : Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.00f, hyo.camy + hyo.wh * 0.35f, si, 99999999, 0, 0, -1,
                getHelpstring("edit")
                , 0, 0, 0, false, kazu: 4));
        }
        player p;
        character c;
        List<weponslot> ws;
        List<character> wsc=new List<character>();
        int _windex;
        weponslot addw=null;
        protected int windex{ get { return _windex; }set { _windex = Math.Min(Math.Max(value,0),ws.Count-1); } }
        protected weponslot selectedws { get { return ws[windex]; } }
        protected character selectewsc { get { return wsc[windex]; } }
        public testedit(player p,SceneManager sm,Scene next,Wepon w=null) : base(sm) 
        {
            this.next = next;
            this.p = p;
            ws = new List<weponslot>(p.WS);

            if (w != null)
            {
                addw = new weponslot(0, 0, 0);
                addw.weponset(w);
                ws.Add(addw);
                _windex = ws.Count -1;
            }
            else 
            {
                _windex = (ws.Count-1) / 2;
            }
        }

        protected override void onstart()
        {
            base.onstart();
            c = new character(p.c,true,true);
            c.scalechange(3);
            c.resethyoji(hyo);
            c.settxy(hyo.ww/2,hyo.wh*0.8f);
            c.mirror = false;
            for (int i=0;i<ws.Count;i++) 
            {
                if (ws[i].wep != null)
                {
                    var c = new character(ws[i].wep.c);
                    c.addmotion(new radtoman(10, "", 0, 360));
                    c.frame(100);


                    wsc.Add(c) ;
                    
                }
                else 
                {
                    wsc.Add(character.onepicturechara(@"effects\soul",1));
                }
                if (wsc[i] != null)
                {
                    wsc[i].resethyoji(hyo);
                    if (wsc[i].w < wsc[i].h)
                    {
                        wsc[i].scalechange(hyo.ww / 10/wsc[i].h);
                    }
                    else
                    {
                        wsc[i].scalechange(hyo.ww / 10 / wsc[i].w);
                    }
                }
            }
            setweps();
        }

        public void setweps() 
        {
            for (int i = 0; i < ws.Count; i++)
            {
              
                wsc[i]?.setcxy(hyo.ww*0.5f+hyo.ww * 0.2f*(i-windex), hyo.wh * 0.4f,wsc[i].w/2, wsc[i].h / 2);
            }
        }

        public override void frame(inputin i, float cl)
        {
            base.frame(i, cl);
            if (i.ok(Keys.D, itype.down)) 
            {
                hyo.playoto("scroll1");
                windex += 1;
                setweps();
            }
            if (i.ok(Keys.A, itype.down))
            {

                hyo.playoto("scroll1");
                windex -= 1;
                setweps();
            }
            if (i.ok(MouseButtons.Left, itype.down))
            {
                Rectangle R = new Rectangle(0, 0);
                for (int j = 0; j < wsc.Count; j++)
                {
                    if (wsc[j] != null)
                    {
                        R.setto(wsc[j]);
                        if (R.onhani(i.x, i.y))
                        {
                            hyo.playoto("scroll1");
                            windex = j;
                            setweps();
                            break;
                        }
                    }
                }
            }
            if (i.ok(MouseButtons.Right, itype.down))
            {
                Rectangle R = new Rectangle(0, 0);
                for (int j = 0; j < wsc.Count; j++)
                {
                    if (ws[j].wep != null&& ws[windex].wep!=null)
                    {
                        R.setto(wsc[j]);
                        if (R.onhani(i.x, i.y))
                        {
                            if (addw == null || (j < wsc.Count - 1 && windex < wsc.Count - 1))
                            {
                               
                                hyo.playoto("scroll1");
                                var aas = selectedws.wep;
                                var bbs = ws[j].wep;
                                if (aas != bbs)
                                {
                                    aas.unsoubi();
                                    bbs.unsoubi();

                                    if (windex < j)
                                    {
                                        bbs.soubi(p);
                                        aas.soubi(p);
                                    }
                                    else
                                    {
                                        aas.soubi(p);
                                        bbs.soubi(p);
                                    }
                                    var god = wsc[windex];
                                    wsc[windex] = wsc[j];
                                    wsc[j] = god;
                                }
                                setweps();
                                break;
                            }
                            else if(j!=windex)
                            {
                                var selectedws = this.selectedws; 
                            
                                var tc = selectewsc;
                                int wcind = windex;
                                if (selectedws == addw) 
                                {
                                    selectedws = ws[j];
                                    tc = wsc[j];
                                    wcind = j;
                                }
                                if (selectedws.wep != null && addw != selectedws)
                                {
                                    hyo.playoto("soubi_hazusu");
                                    hyo.playoto("soubi_tukeru");
                                    var twep = selectedws.wep;
                                    twep.unsoubi();




                                    addw.wep.soubi(p);
                                    addw.weponunset(addw.wep);

                                    addw.weponset(twep);

                                    wsc[wcind] = wsc.Last();
                                    wsc[wsc.Count - 1] = tc;

                                    setweps();
                                }
                                break;
                            }
                        }
                    }
                }
            }

            {
                float size=20;
                message.hutidorin(size/15,0,hyo.wh*0.68f,size,(int)(hyo.ww*2/size),0,0,cl,p.s.printstatus(),0,0,0,false,9999999,hyo);


                string weps="";
                float R = 0, B = 0, G = 0, BR = 1, BG = 1, BB = 1;
                if (addw != null && windex == ws.Count - 1) 
                {
                    weps+= FP.GT("SSkieruwep")+"\n";
                    R = 1;
                }
                if (selectedws.wep != null)
                {
                    weps += selectedws.wep.getname() + "\n" +
                         selectedws.wep.getsetumei() + "\n" + selectedws.wep.s.printstatus();
                }
                else
                {
                    weps += FP.GT("SSnonewep");
                }
                message.hutidorin(size / 15, 0, hyo.wh * 0.23f, size, (int)(hyo.ww * 2 / size), 0, 0, cl, weps, R, G, B, false, 9999999, hyo,false,BR,BG,BB);

            }
            if (i.ok(Keys.Escape, itype.down))
            {
                end();
            }
            if (addw != null)
            {
                if (i.ok(Keys.Space, itype.down))
                {
                    if (selectedws.wep != null && addw != selectedws)
                    {
                        hyo.playoto("soubi_hazusu");
                        hyo.playoto("soubi_tukeru");
                        var twep = selectedws.wep;
                        var tc = selectewsc;
                        twep.unsoubi();




                        addw.wep.soubi(p);
                        addw.weponunset(addw.wep);

                        addw.weponset(twep);

                        wsc[windex] = wsc.Last();
                        wsc[wsc.Count - 1] = tc;

                        setweps();
                    }
                }

            }
            p.UIn(i,hyo,cl,false);
        }

    }


    class tyantoget : testget 
    {
        float bai;itemtype ty;
        int cou;
        public tyantoget(SceneManager sm, player p, rank r,itemtype type,float bai,int cou,Scene next) : base(sm, p, r, next) 
        {
            this.bai = bai;
            this.ty = type;
            this.cou = cou;
        }
        protected override void genecards()
        {
            cards.Clear();
            cards = SD.S.sin.getcards(hyo.ww * 0.20f, r,bai,ty,cou);
        }
    }
    class gouseiget : testget
    {
        Wepon w;
        public gouseiget(SceneManager sm, player p, rank r, Wepon w,  Scene next) : base(sm, p, r, next)
        {

           this.w = w;

        }
        protected override void genecards()
        {
            cards.Clear();
            cards.Add(new itemcard(hyo.ww * 0.2f,w,r));
        }
        override protected void selectcard(itemcard a)
        {
            if (a.getcard(p))
            {
                end();
            }
            else
            {
                this.next = new testedit(p, sm, this.next, a.GetWepon());
                end();
            }
        }
    }
    class testget :Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.00f, hyo.camy + hyo.wh * 0.00f, si, 99999999, 0, 0, -1,
                getHelpstring("get")
                , 0, 0, 0, false, kazu: 4));
        }
        protected player p;
        protected List<itemcard> cards = new List<itemcard>();
        protected rank r;
        public testget(SceneManager sm,player p,rank r, Scene next) : base(sm) 
        {
            this.p = p;
            this.next = next;
         
            this.r = r;
            float si = hyo.ww / 25;
            message.hutidorin(si/20,hyo.ww/2,hyo.wh*0.02f,si,100,50,0,-1,FP.GT("Get"),0,0,1,false,1E+09f,hyo,false,0.1f,1,0,-1,4);
        }

        virtual protected void genecards() 
        {
            cards.Clear();
            cards = SD.S.sin.getcards( hyo.ww * 0.20f,r);
        }
      
        protected override void onstart()
        {

          
            base.onstart();
            genecards();
            foreach (var a in cards) a.resethyoji(hyo);
            cardset();
        }
        protected override void onend()
        {
            
            base.onend();
        }
        public override void frame(inputin i, float cl)
        {

            foreach (var a in cards) a.frame(cl);
            if (i.ok(MouseButtons.Left, itype.down))
            {
                foreach (var a in cards)
                {
                    if (a.on(i))
                    {
                        
                        hyo.playoto("kettei");
                        selectcard(a);
                        break;
                    }
                }
            }
            if (i.ok(Keys.Escape, itype.down))
            {
                new testedit(p, sm, this).start();
            }
            base.frame(i, cl);
        }
        virtual protected void selectcard(itemcard a) 
        {
            if (a.getcard(p))
            {
                end();
            }
            else
            {
                var lis = new List<Wepon>();
                if (a.GetWepon() != null) lis.Add(a.GetWepon());
                this.next = new testgousei(p, sm, lis, this.next);
                end();
            }
        }
        void cardset() 
        {
            for (int i = 0; i < cards.Count; i++) 
            {
                cards[i].settxy(hyo.ww*(i+1)/(cards.Count+1),hyo.wh*(0.23f)*(i%2*2+1.3f));
            }
        }
    }
 
    class testmap :Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.00f, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("map")
                , 0, 0, 0, false, kazu: 4));
        }
        player p;
        player lastselect=null;
        picture sun;
        List<player> enes = new List<player>();
        List<message> mm;
        public testmap(player p, SceneManager sm) : base(sm)
        {
            hyo.bairitu = 2;
            sun= new picture(-100000, -100000, 99999999999,hyo.ww/10,hyo.ww/10,hyo.ww/10/2,hyo.wh/10/2
                ,0,false,0.5f,"def",new Dictionary<string, string> {{"def","sun"} });
            this.p = p;
            float si = hyo.ww * 0.05f;
            message.hutidorin(si/20,hyo.ww/2,hyo.wh*0.25f,si,100,50,0,-1,FP.GT("Map"),1,0,0,false,1E+09f,hyo,false,1f,0.7f,0);
            var pp = picture.onetexpic("ui\\map", hyo.ww *0.4f, tx:hyo.ww / 2, ty:hyo.wh * 0.25f) ;
            pp.add(hyo);
        }
        protected override void onstart()
        {
            geneenes();

            base.onstart();
            setenes();

            sun.add(hyo);
            select(enes[0]);
            new message(0, hyo.wh*0.9f, 32, 99999, 0, 0, -1, SD.S.sin.Fase.ToString()).add(hyo);
        }
        virtual protected void geneenes()
        {

            enes = SD.S.sin.getenemy(5);
        }
        protected void setenes()
        {
            float size = hyo.wh * 0.02f;
            for (int i = 0; i < enes.Count; i++)
            {
                enes[i].c.settxy(hyo.ww * (i + 1) / (enes.Count + 1) + ((i - (enes.Count - 1) / 2) * hyo.ww / 100), hyo.wh *0.55f);
                enes[i].c.resethyoji(hyo);

                string text=enes[i].s.printstatus(false);
                foreach (var a in enes[i].WS) 
                {
                    if (a.wep != null)
                    {
                        a.wep.c.resethyoji(hyo);
                        text += a.wep.getname() + a.wep.getsetumei() + a.wep.s.printstatus();
                    }
                }
                /*mm = message.hutidorin(size / 15, hyo.ww * (i + 1) / (enes.Count + 1) + ((i - (enes.Count - 1) / 2) * hyo.ww / 100)
                - hyo.ww * (1) / (enes.Count + 1) / 2, hyo.wh * 0.7f, size, (int)(hyo.ww * (1) / (enes.Count + 1) * 2 / size), 0, 0, -1,

                , hyo: hyo);*/


            }
           mm= message.hutidorin(size / 15, hyo.ww * (0.1f) 
                  , hyo.wh * 0.7f, size, (int)(hyo.ww * (0.9f)  * 2 / size), 0, 0, -1,""
                  , 0,0,0,false,hyo: hyo);

        }
        void select(player p) 
        {
            lastselect = p;
            
            string text = p.s.printstatus(false); 
            foreach (var a in p.WS)
            {
                if (a.wep != null)
                {
                    a.wep.c.resethyoji(hyo);
                    text += "\n"+a.wep.getname() +" : "+ a.wep.getsetumei() +"\n"+ a.wep.s.printstatus();
                }
            }
            foreach (var a in mm) 
            {
                a.text = text;
            }
            sun.settxy(p.c.gettx(), p.c.getty());
        }
        public override void frame(inputin i, float cl)
        {
            base.frame(i, cl);

            foreach (var a in enes)
            {
                a.c.frame();
                foreach (var b in a.WS)
                {
                    b.soroewep();
                }
                a.ab.frame();
                if (a.Acore.onhani(i.x, i.y))
                {
                    select(a);   
                }
            }
            if (i.ok(MouseButtons.Left, itype.down))
            {

                {
                    Shape rec = new Circle(0, 0);
                    rec.setto(sun);
                    if (rec.onhani(i.x, i.y))
                    {
                        fileman.playoto("kettei");
                        next = new test(sm, p, lastselect);
                        end();
                    }
                }

            }
            if (i.ok(Keys.Space, itype.down)) 
            {
                fileman.playoto("kettei");
                next = new test(sm, p, lastselect);
                end();
            }
            if (i.ok(Keys.D, itype.down))
            {
                int jk = enes.IndexOf(lastselect);
                jk += 1;
                if (jk >= enes.Count) jk = 0;
                select(enes[jk]);
                fileman.playoto("scroll1");
            }
            if (i.ok(Keys.A, itype.down))
            {
                int jk = enes.IndexOf(lastselect);
                jk -= 1;
                if (jk < 0) jk = enes.Count-1;
                select(enes[jk]);
                fileman.playoto("scroll1");
            }
            if (i.ok(Keys.Escape, itype.down))
            {
                new testedit(p, sm, this).start();
            }
           
            lastselect?.UIn(i, hyo, cl, false);
        }

    }
    class treasure 
    {
        protected rank r;
        protected itemtype t;
        protected int num;
        protected float bai;

        public treasure(rank r, itemtype t, int num, float bai) 
        {
            this.r = r;
            this.t = t;
            this.num = num;
            this.bai = bai;
        }

        public character getCharacter(float si) 
        {
            var res = character.onepicturechara(@"card\"+t.ToString(), si,0);

            res.core.sts.Add(new setu("back",res.tx,res.ty,new picture(0,0,-1,res.w,res.h,res.tx,res.ty
                ,0,false,1,"def",new Dictionary<string, string> { {"def",@"card\"+r.ToString() } })));

            return res;
        }
       virtual public string getString() 
        {
            return FP.GT("SS"+t.ToString())+" : "+FP.GT("SS"+r.ToString())+" * "+num.ToString();
        }
       virtual public void go(Scene back,player p, SceneManager sm) 
        {
            var s=new tyantoget(sm, p, r, t, bai, num, back);
            s.start();
        }
    }
    class gouseitreasure:treasure
    {
        Wepon w;
        public gouseitreasure(rank r, Wepon w):base(r,itemtype.wepon,1,w.power)
        {
            this.w = w;
           
        }

        override public string getString()
        {
            return FP.GT("SS" + t.ToString()) + " : " +  w.getname();
        }
       override public void go(Scene back, player p, SceneManager sm)
        {
            var s = new gouseiget(sm, p, r, w, back);
            s.start();
        }
    }

    class testtreasure : Scene 
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.00f, hyo.camy + hyo.wh * 0.00f, si, 99999999, 0, 0, -1,
                getHelpstring("treasure")
                , 0, 0, 0, false, kazu: 4));
        }
        player p;
        List<treasure> lis;
        List<character> clis=new List<character>();
        List<message> ms = new List<message>();
       
        public testtreasure(player p,List<treasure> tres, Scene next, SceneManager sm,bool gousei=false) : base(sm) 
        {
            this.p = p;
            lis = tres;
            this.next = next;
            var tex = "ui\\treasure";
            var text = "Treasure";
            if (gousei)
            {
                tex = "ui\\gouseitreasure";
                text = "GouseiTreasure";
            }
            var tre = picture.onetexpic(tex,hyo.ww*0.3f,tx:hyo.ww*0.20f, ty: hyo.wh * 0.5f);
            tre.add(hyo);
            float si = hyo.ww * 0.05f;
            message.hutidorin(si/18f,tre.gettx(),tre.getty()-tre.h*0.3f,si,100,50,0,-1,FP.GT(text),0,0,0,false,hyo:hyo);
        }
        protected void setc()
        {
            foreach (var a in clis) foreach (var b in a.getallsetu()) b.p.remove(hyo);

            foreach (var a in ms) a.remove(hyo);
            clis.Clear();
            for (int i = 0; i < lis.Count; i++)
            {
                clis.Add(lis[i].getCharacter(hyo.ww * 0.05f));
                clis[i].settxy(hyo.ww * 0.45f, hyo.ww * 0.05f * ((i-lis.Count/2f)*1.5f)+hyo.wh*0.45f);
                float si = hyo.ww * 0.02f;
               ms.AddRange( message.hutidorin(si / 15, hyo.ww * 0.55f, hyo.ww * 0.05f * ((i - lis.Count / 2f) * 1.5f) + hyo.wh * 0.45f, si, (int)(hyo.ww * 0.7f / si * 2), 0, 0, -1
                    , lis[i].getString(),0,0,0,false,hyo:hyo));
                clis[i].resethyoji(hyo);
            }
            
        }
        public override void start()
        {
            
            base.start();
            setc();
        }
        Rectangle rrr = new Rectangle(0, 0);
        public override void frame(inputin i, float cl)
        {
            base.frame(i, cl);

            if (lis.Count == 0)
            {
                fileman.playoto("kettei");
                end();
                return;
            }
            if (i.ok(Keys.Escape, itype.down))
            {
                fileman.playoto("kettei");
                new testedit(p,sm,this).start();
                // end();
            }
            foreach (var a in clis) a.frame();
            if (i.ok(MouseButtons.Left, itype.down))
            {
                for (int j = 0; j < clis.Count; j++)
                {
                    rrr.setto(clis[j]);
                    if (rrr.onhani(i.x, i.y))
                    {
                        lis[j].go(this, p, sm);
                        lis.RemoveAt(j);
                        setc();
                        fileman.playoto("kettei");
                        break;
                    }
                }
              
            }
           
        }

    }

    class testgousei : Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0, hyo.camy + hyo.wh * 0, si, 99999999, 0, 0, -1,
                getHelpstring("gousei")
                , 0, 0, 0, false, kazu: 4));
        }
        List<Wepon> inp=new List<Wepon>();
        List<character> sets = new List<character>();
        List<Wepon> res=new List<Wepon>();
        List<Wepon> addw;

        List<message> m;

        player p;

        GameSet1.benriUI.rolling r,r2;
        public testgousei(player p,SceneManager sm,List<Wepon>w, Scene next) : base(sm)
        {
            this.next = next;
            this.p = p;
            addw = w;
            hyo.bairitu *= 1.5f;

            var si=hyo.ww / 50;
            m = message.hutidorin(si / 15, hyo.ww / 2, hyo.wh / 2, si, 100, 50, 0, -1, "",0,0,0,false, hyo: hyo);


            picture.onetexpic("ui\\gousei", hyo.ww * 0.4f, -2000, tx: hyo.ww / 2, ty: hyo.wh * 0.3f).add(hyo);

            si *= 3;
            message.hutidorin(si / 18, hyo.ww / 2, hyo.wh * 0.10f, si, 100, 50, 0, -1, FP.GT("Gousei"), 95/255f, 135/255f, 175/255f, false, hyo: hyo);
            new picture(hyo.ww / 2 - 30, hyo.wh * 0.0f, -1000, 60, hyo.wh, 30, 0, 0, false, 0.3f, "def", new Dictionary<string, string> { { "def", "pinkbit" } }).add(hyo);

        }
        protected override void onstart()
        {
            p.add(new EntityManager(hyo));
            p.remove();
            p.c.sinu(hyo);
            var lis = new List<character>();
            for (int i = 0; i < p.WS.Count; i++)
            {
                if (p.WS[i].wep != null)
                {
                    p.WS[i].wep.c.frame(1000);
                    p.WS[i].wep.c.copykakudo(p.WS[i].wep.c.getkijyun());
                    p.WS[i].wep.c.settxy(hyo.ww * 0.12f * i + hyo.ww / 2, hyo.wh * 0.3f);
                    lis.Add(p.WS[i].wep.c);
                  
                }
            }
            for (int i = 0; i < addw.Count; i++)
            {
                addw[i].c.settxy(hyo.ww * 0.12f * (i+p.WS.Count) + hyo.ww / 2, hyo.wh * 0.3f);
                lis.Add(addw[i].c);
            }
            r = new GameSet1.benriUI.rolling(hyo, p.WS.Count / 2, 10, lis, new Circle(0, 0));
            r.start();

         
            base.onstart();

        }
        protected Wepon getw(int i) 
        {
            var res=getw(r.getchara(i));
            if (res == null) res = getw(r2.getchara(i));
            return res;

        }
        protected Wepon getw(character c)
        {
            foreach (var a in p.WS)
            {
                if (a.wep != null && a.wep.c == c)
                {
                    return a.wep;
                }
            }
            foreach (var a in addw)
            {
                if (a.c == c)
                {
                    return a;
                }
            }
            foreach (var a in res)
            {
                if (a != null && a.c == c)
                {
                    return a;
                }
            }
            return null;

        }
        protected void kiriyotei(Wepon w) 
        {
            if (inp.Contains(w))
            {
                removeyotei(w);
            }
            else
            {
                addyotei(w);
            }
        } 
        protected void addyotei(Wepon w) 
        {
            inp.Add(w);
            var c = character.onepicturechara("effects\\sun",(w.c.w+w.c.h)*0.8f,w.c.core.p.z+=100,false,tx:w.c.gettx(),ty:w.c.getty());
            sets.Add(c);
            c.resethyoji(hyo);
            fileman.playoto("soubi_tukeru");
            setres();
        }
        protected void removeyotei(Wepon w)
        {
            int i = inp.IndexOf(w);
            inp.Remove(w);
            sets[i].sinu(hyo);
            sets.RemoveAt(i);

            fileman.playoto("soubi_hazusu");
            setres();
        }

        protected void setres()
        {
            r2?.end();
            
            res.Clear();

            res.AddRange(Sintyokun.gousei(inp));

            var lis = new List<character>();
            for(int i=0;i<res.Count;i++) 
            {
                var a = res[i];
                a.c.settxy(hyo.ww * 0.1f * i + hyo.ww / 2, hyo.wh * 0.7f);
                lis.Add(a.c);
            }
            if (res.Count > 0)
            {

                r2 = new GameSet1.benriUI.rolling(hyo, 0, 10, lis, new Circle(0, 0));
                r2.start();
            }
            else 
            {
                r2 = null;
            }

            var ss = Sintyokun.tyusituzokusei(inp);
  
            foreach (var a in m) 
            {
                a.text = Math.Round(Sintyokun.tyusitupower(inp),2)+":";
                
                foreach (var b in ss) { a.text += FP.GT("SN" + b.ToString()); }
                
            }

        }

        public override void frame(inputin i, float cl)
        {
         
            {
                for (int j = 0; j < sets.Count; j++) 
                {
                    sets[j].settxy(inp[j].c.gettx(), inp[j].c.getty());
                    sets[j].frame(cl);
                }
            }
            if (r.nowidx >= 0)
            {
                var wep = getw(r.selected().First());
                if (wep != null)
                {
                    float size = hyo.ww / 80;

                    string text = wep.getname()+"\n"+wep.getsetumei()+"\n"+wep.s.printstatus();
                   
                    message.hutidorin(size / 15, hyo.camx + hyo.ww * (0.1f)
                    , hyo.camy + hyo.wh * 0.4f, size, (int)(hyo.ww * (0.9f) * 2 / size), 0, 0, cl, text
                    , 0, 0, 0, false, hyo: hyo);
                } 
            }
            if(r2!=null&& r2.nowidx >= 0)
            {
                var wep = getw(r2.selected().First());
                if (wep != null)
                {
                    float size = hyo.ww / 80;

                    string text = wep.getname() + "\n" + wep.getsetumei() + "\n" + wep.s.printstatus();

                    message.hutidorin(size / 15, hyo.camx + hyo.ww * (0.1f)
                    , hyo.camy + hyo.wh * 0.8f, size, (int)(hyo.ww * (0.9f) * 2 / size), 0, 0, cl, text
                    , 0, 0, 0, false, hyo: hyo);
                }
            }
            if (i.ok(Keys.D, itype.ing))
            {
                if (r.idou(1)) hyo.playoto("scroll1");
                if (r2!=null&&r2.idou(1)) hyo.playoto("scroll1");

            }
            if (i.ok(Keys.A, itype.ing))
            {
                if (r.idou(-1)) hyo.playoto("scroll1");
                if (r2 != null && r2.idou(-1)) hyo.playoto("scroll1");
            }
            if (i.ok(MouseButtons.Left, itype.down))
            {
                {
                    var s = r.clickeds(i.x, i.y);
                    if (s.Count > 0)
                    {
                        if (r.idou(s[0])) hyo.playoto("scroll1");
                        else
                        {

                            fileman.playoto("TB\\kettei");
                        }
                    }
                }
                if (r2 != null)
                {
                    var s = r2.clickeds(i.x, i.y);
                    if (s.Count > 0)
                    {
                        if (r2.idou(s[0])) hyo.playoto("scroll1");
                        else
                        {

                            fileman.playoto("TB\\kettei");
                        }
                    }
                }
            }
            if (i.ok(Keys.Space, itype.down))
            {
                var a = r.selected();
                if ( a.Count > 0)
                {
                    kiriyotei(getw(a[0]));
                }
            }
            if (i.ok(Keys.G, itype.down)&&res.Count>0)
            {
                fileman.playoto("tatebash");
                foreach (var b in inp) b.unsoubi();
                foreach (var b in inp) addw.Remove(b);
                    var a = new List<treasure>();
             
                foreach (var b in res)   a.Add(new gouseitreasure(rank.def,b));
                next = new testtreasure(p,a,this.next,sm,true);
                end();
            }
            else if (i.ok(Keys.Escape, itype.down))
            {
              
              
                end();
            }
           

            r.frame(cl);
            r2?.frame(cl);
            base.frame(i, cl);

        }
        public override void end()
        {
            for (int i = addw.Count-1; i >=0; i--) 
            {
                if (addw[i].soubi(p)) addw.RemoveAt(i);
            }
            var lis = new List<Scene>();
            for (int j = 0; j < addw.Count; j++)
            {
                lis.Add(new testedit(p, sm, this.next, addw[j]));
                if (j > 0) lis[j - 1].next = lis[j];
                else this.next = lis[j];
            }
            base.end();
        }
        protected override void onend()
        {
            r.end();
            r2?.end();
            base.onend();
        }
    }
}
