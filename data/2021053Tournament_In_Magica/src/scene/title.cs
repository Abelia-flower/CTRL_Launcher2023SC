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
using C2WebRTCP2P;
using GameSet1.benriUI;

namespace THE_Tournament.scene
{
    class title : Scene
    {
        GameSet1.benriUI.buttoninterface b;

        character ti;

        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0, hyo.camy + hyo.wh * 0, si, 99999999, 0, 0, -1,
                getHelpstring("title")
                , 0, 0, 0, false, kazu: 4));
        }

        public title(SceneManager s) : base(s)
        {
            float size = hyo.wh * 0.1f;
            float si = hyo.ww / 30;
            var lis = new List<character>();
            float takasa = 0.52f;
            lis.Add(character.onepicturechara("effects\\tim", size, 0, false, 0.5f, 0.5f, 1, 0, hyo.ww / 2, hyo.wh * takasa));
            message.hutidorin(si / 15, hyo.ww / 2 + si / 2, hyo.wh * takasa + si, si, 100, 50, 0, -1, FP.GT("Tournament"), 0, 0, 0, false, hyo: hyo);

            lis.Add(character.onepicturechara("effects\\soul", size, 0, false, 0.5f, 0.5f, 1, 0, hyo.ww * 3 / 4, hyo.wh * takasa));
            message.hutidorin(si / 15, hyo.ww * 3 / 4 + si / 2, hyo.wh * takasa + si, si, 100, 50, 0, -1, FP.GT("History"), 0, 0, 0, false, hyo: hyo);

            lis.Add(character.onepicturechara("ui\\gold", size, 0, false, 0.5f, 0.5f, 1, 0, hyo.ww * 1 / 4, hyo.wh * takasa));
            message.hutidorin(si / 15, hyo.ww * 1 / 4 + si / 2, hyo.wh * takasa + si, si, 100, 50, 0, -1, FP.GT("Shop"), 0, 0, 0, false, hyo: hyo);

            lis.Add(character.onepicturechara("ui\\bossselect", size, 0, false, 0.5f, 0.5f, 1, 0, hyo.ww * 1 / 2, hyo.wh * takasa+hyo.wh*0.24f));
            message.hutidorin(si / 15, hyo.ww * 1 / 2 + si / 2, hyo.wh * takasa+hyo.wh*0.24f + si, si, 100, 50, 0, -1, FP.GT("Boss"), 0, 0, 0, false, hyo: hyo);


            lis.Add(character.onepicturechara("ui\\setting", size, 0, false, 0.5f, 0.5f, 1, 0, hyo.ww -size/2, size/2));
            message.hutidorin(si / 15, hyo.ww -size/2 + si / 2, size/2+si, si, 100, 100, 0, -1, FP.GT("Setting"), 0, 0, 0, false, hyo: hyo);


            b = new GameSet1.benriUI.buttoninterface(hyo, 0
                , character.onepicturechara("effects\\sun", hyo.wh * 0.15f, 10, false, 0.5f, 0.5f, 0.7f, 0)
                , lis, new Circle(0, 0));

            ti = character.onepicturechara("title", hyo.ww * 0.65f, 0, false, tx: hyo.ww / 2, ty: hyo.wh * 0.23f);
            ti.resethyoji(hyo);
        }
        public override void start()
        {
            base.start();
            b.start();
            SD.savesave<SD>();
            for (int iss = 0; iss < 50; iss++)
            {
                makeeff(hyo);
            }
        }
        protected void settips() 
        {
            if (tips == null || !tips[0].onhyoji(hyo)) 
            {
                float time = 600;
                float si = hyo.ww / 45;
                tips = message.hutidorin(si/19,hyo.ww*0.03f,hyo.wh*0.91f,si,(int)(hyo.ww/si*2),0,0,time,gettips(),0,0,0,false,hyo:hyo);
                foreach (var a in tips) 
                {
                    a.setfadein(Math.Min(time/10,30), Math.Min(time / 20, 15));
                    a.setfadeout(time- Math.Min(time / 10, 30), Math.Min(time / 10, 30));
                }
            }
        }
        protected string gettips() 
        {
            if (nowpics.Count == 0)
            {
                nowpics = genetips();
            }
            int i = fileman.r.Next() % nowpics.Count;
            var tt = nowpics[i];
            nowpics.RemoveAt(i);
            return tt;
        }
        
        List<message> tips=null;
       
        public override void frame(inputin i, float cl)
        {
            base.frame(i, cl);
            settips();
            for (int iss = 0; iss < 2; iss++)
            {
                makeeff(hyo);
            }

            if (i.ok(MouseButtons.Left, itype.down))
            {
                var lis = b.clickeds(i.x, i.y);
                if (lis.Count > 0)
                {
                    if (!b.select(lis.First()))
                    {
                        end();
                    }
                    else
                    {
                        hyo.playoto("scroll1");
                    }
                }
            }
            if (i.ok(Keys.W, itype.down))
            {
                hyo.playoto("scroll1");
                b.selectsaikinbosi(false, true);
            }
            if (i.ok(Keys.S, itype.down))
            {
                hyo.playoto("scroll1");
                b.selectsaikinbosi(true, true);
            }
            if (i.ok(Keys.A, itype.down))
            {
                hyo.playoto("scroll1");
                b.selectsaikinbosi(false, false);
            }
            if (i.ok(Keys.D, itype.down))
            {
                hyo.playoto("scroll1");
                b.selectsaikinbosi(true, false);
            }
            if (i.ok(Keys.Space, itype.down))
            {
                end();
            }

        }
        public override void end()
        {

            var lis = b.selected();
            if (lis.Count > 0)
            {
                if (lis[0].core.p.nowtex == "effects\\tim")
                {
                    var ups = SD.S.getupgrade();
                    {
                        var p = Sintyokun.getstdplayer();
                        SD.S.startplayer();
                        ups.getRelics().ForEach((a) => a.add(p));
                        //  SD.S.goPlayerScript(p);

                        var llis = ups.getTreasures();

                        next = new testtreasure(p, llis, new testmap(p, sm), sm);


                    }
                }
                else if (lis[0].core.p.nowtex == "effects\\soul")
                {
                    if (SD.S.goallPlayerScript().Count > 0)
                    {
                        next = new history(sm, new title(sm));
                    }
                    else
                    {
                        fileman.playoto("TB\\buu");
                        return;
                    }
                }
                else if (lis[0].core.p.nowtex == "ui\\gold")
                {

                    next = new shop(sm, new title(sm));

                }
                else if (lis[0].core.p.nowtex == "ui\\bossselect")
                {

                    next = new bossselect(sm, new title(sm));

                }
                else if (lis[0].core.p.nowtex == "ui\\setting")
                {

                    next = new Setting(sm, new title(sm));

                }
            }
            fileman.playoto("kettei");
            base.end();
        }

        static List<string> nowpics = new List<string>();
        public static List<string> genetips() 
        {
            var res = new List<string>();
            for (int i = 0; i < 100; i++) 
            {
                var st = FP.GT("Tips" + i);
                if (FP.nulltext(st))
                {
                    break;
                }
                else 
                {
                    res.Add(st);
                }
            }
            return res;
        }

    }
    class history : Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("history")
                , 0, 0, 0, false, kazu: 4));
        }
        List<player> ps;
        EntityManager em;
        GameSet1.benriUI.rolling r;
        public history(SceneManager sm, Scene next) : base(sm)
        {
            this.next = next;
            em = new EntityManager(hyo);
            ps = SD.S.goallPlayerScript();
            hyo.bairitu *= 1.5f;
            var lis = new List<character>();
            var adds = new List<character>();
            for (int i = 0; i < ps.Count; i++)
            {

                ps[i].c.settxy(hyo.ww * 0.2f * i + hyo.ww / 2, hyo.wh / 2);
                lis.Add(ps[i].c);
                foreach (var a in ps[i].WS) 
                {
                    if (a.wep != null) 
                    {
                        a.soroewep();
                        adds.Add(a.wep.c);
                    }
                }
            }
            r = new GameSet1.benriUI.rolling(hyo, ps.Count / 2, 10, lis, new Circle(0, 0),adds);

            new picture(hyo.ww / 2 - 50, hyo.wh * 0.0f, -1000, 100, hyo.wh, 50, 0, 0, false, 0.3f, "def", new Dictionary<string, string> { { "def", "pinkbit" } }).add(hyo);
            float si = hyo.ww / 30;
            message.hutidorin(si / 18, hyo.ww * 0.5f, hyo.wh * 0.22f, si, 100, 50, 0, -1, FP.GT("History2"), hyo: hyo, kazu: 4);
            picture.onetexpic("effects\\soul", hyo.ww * 0.2f, -10000, false, 0.5f, 0.35f, tx: hyo.ww * 0.5f, ty: hyo.wh * 0.20f).add(hyo);


        }
        protected override void onstart()
        {
            r.start();
            foreach (var a in ps) a.add(em);
        
            base.onstart();

        }
        public override void frame(inputin i, float cl)
        {
            if (r.nowidx >= 0)
            {
                ps[r.nowidx].UIn(i, hyo, cl, false);
                float size = hyo.ww / 60;

                string text = FP.GT("SSurine", null, ps[r.nowidx].fase) + "\n" + ps[r.nowidx].s.printstatus(false);
                foreach (var a in ps[r.nowidx].WS)
                {
                    if (a.wep != null)
                    {
                        a.wep.c.resethyoji(hyo);
                        text += "\n" + a.wep.getname() + " : " + a.wep.getsetumei() + "\n" + a.wep.s.printstatus();
                    }
                }

                message.hutidorin(size / 15, hyo.camx + hyo.ww * (0.1f)
                , hyo.camy + hyo.wh * 0.66f, size, (int)(hyo.ww * (0.9f) * 2 / size), 0, 0, cl, text
                , 0, 0, 0, false, hyo: hyo);
            }
            if (i.ok(Keys.D, itype.ing))
            {
                if (r.idou(1)) hyo.playoto("scroll1");
            }
            if (i.ok(Keys.A, itype.ing))
            {
                if (r.idou(-1)) hyo.playoto("scroll1");
            }
            if (i.ok(MouseButtons.Left, itype.down))
            {
                var s = r.clickeds(i.x, i.y);
                if (s.Count > 0)
                {
                    if (r.idou(s[0])) hyo.playoto("scroll1");
                }
            }
            if (i.ok(Keys.Space, itype.down))
            {
                var a = r.selected();
                if (ps.Count > 1 && a.Count > 0)
                {
                   
                    SD.S.gaingold(ps[r.nowidx].fase);
                    SD.S.removeplayerScript(r.nowidx);
                    ps[r.nowidx].remove();
                    ps.RemoveAt(r.nowidx);

                    r.removecharas(a[0]);
                    fileman.playoto("TB\\jarin"); 
                    r.idou(-1);
                }
                else 
                {
                    SD.S.gaingold(ps[r.nowidx].fase);
                    SD.S.removeplayerScript(r.nowidx);
                    ps[r.nowidx].remove();
                    ps.RemoveAt(r.nowidx);

                    r.removecharas(a[0]);
                    fileman.playoto("TB\\jarin");
                    end();
                }
            }
            if (i.ok(Keys.G, itype.down))
            {
                fileman.playoto("sippai");
                markkaijo();

            }
            if (i.ok(Keys.Escape, itype.down))
            {
                end();
            }
            else if (i.ok(Keys.T, itype.down))
            {
                fileman.playoto("kettei");
                mark(r.nowidx);

            }
            /*else if (i.ok(Keys.G, itype.down))
            {
                fileman.playoto("kettei");
                int me = r.nowidx;

                var mee = Sintyokun.getstdplayer("me");




                //   Console.WriteLine(mee.s.mhel + " aslfma;l " + hee.s.mhel);
                SD.S.goPlayerScript(mee, me);
                //       Console.WriteLine(mee.s.mhel + " aslfma;l " + hee.s.mhel);


                new testgousei(mee, sm, Sintyokun.getstdwepons(2, rank.bubble), new history(sm, this.next)).start();
            }*/
            else if(i.ok(Keys.R,itype.down))
            {
                var a = r.selected();
                if (a.Count > 0)
                {
                    new Hyperconnect(SD.getPlayerScript(ps[r.nowidx]),sm, new history(sm, this.next)).start();
                }
                else 
                {
                    fileman.playoto("TB\\buu");
                }
            }


         
            r.frame(cl);
            base.frame(i, cl);

        }
        protected override void onend()
        {
            r.end();
            base.onend();
        }


        character marker = character.onepicturechara("sun", 64, -10);
        int marked = -1;
        protected void markkaijo() 
        {
            r.adds.Remove(marker);
            marker.sinu(hyo);
            marked = -1;
        }
        protected void mark(int idx)
        {
            if (r.selected().Count == 0) return;
            var sel = r.selected()[0];
            if (marked == -1)
            {

                marker.settxy( sel.gettx(),  sel.getty());
                r.adds.Add(marker);
                marker.resethyoji(hyo);
                marked = r.nowidx;
            }
            else 
            {

                var mes = new List<player>(); 
                var hes = new List<player>();
                
                {
                    int me = marked;
                    int he = r.nowidx;

                    var mee = Sintyokun.getstdplayer("me");
                    var hee = Sintyokun.getstdplayer("he");


                   

                    //   Console.WriteLine(mee.s.mhel + " aslfma;l " + hee.s.mhel);
                    SD.S.goPlayerScript(mee, me);
                    SD.S.goPlayerScript(hee, he);
                    //       Console.WriteLine(mee.s.mhel + " aslfma;l " + hee.s.mhel);

                    //    hee = Sintyokun.getstdenemy(Sintyokun.stdbai(mee.fase), 4, mee.fase, mee.fase, rank.bubble);
                    mes.Add(mee);
                    hes.Add(hee);
                }
                float mesum = 0, hesum = 0 ;
                foreach (var a in mes) { mesum += a.s.mhel; }
                foreach (var a in hes) { hesum += a.s.mhel; }
             

                markkaijo();

                new historyVS(sm, mes, hes, new history(sm, this.next)).start();
            }
        }
    }

    class historyVS : battlebase
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.05f, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("VS", "historyVS")
                , 0, 0, 0, false, kazu: 4));
        }
        public historyVS(SceneManager sm, List<player>  p, List<player> e, Scene next) : base(sm,  p,e)
        {
            this.next = next;
        }
        protected override void onstart()
        {
            base.onstart();
            me.autoskill = true;
            he.autoskill = true;

        }


        public override void frame(inputin i, float cl)
        {
            if (i.ok(Keys.T, itype.down))
            {
                var she = me;
                me = he;
                he = she;
                var shehp = mehp;
                mehp = hehp;
                hehp = shehp;
                me.autoskill = false;
                he.autoskill = true;
            }
            if (i.ok(Keys.Y, itype.down))
            {
                me.autoskill = !me.autoskill;

            }
            cl = gogotokei(cl);

            if (i.ok(Keys.Escape, itype.down))
            {

                end();
            }
            base.frame(i, cl);

        }
    }
    class Hyperconnect :Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.01f, hyo.camy + hyo.wh * 0.41f, si, 99999999, 0, 0, -1,
                getHelpstring("Hyperconnect")
                , 0, 0, 0, false, kazu: 4));
        }
        string me;
        buttoninterface b;
        character saw;
        List<message> see;
        public Hyperconnect(string  p, SceneManager sm, Scene next) : base(sm) 
        {
            this.next = next;
            me = p;
            float si = hyo.ww * 0.08f;
            float sii = si / 4;
            saw = character.onepicturechara("nothing", si*1.5f, 10, false, tx: hyo.ww * 0.5f, ty: hyo.wh * 0.4f);
            saw.core.p.textures.Add("bogo","enemy\\Bogo");
            saw.core.p.textures.Add("bubble", "enemy\\Bubble");
            var lis = new List<character>();
            
            lis.Add(character.onepicturechara("ui\\bogo", si, 10, tx: hyo.ww * 0.25f, ty: hyo.wh * 0.7f));
            message.hutidorin(sii / 18, hyo.ww * 0.25f, hyo.wh * 0.7f + si / 2, sii, 100, 50, 0, -1, FP.GT("BogoConnect"), hyo: hyo, kazu: 2);

            lis.Add(character.onepicturechara("ui\\battleclear", si, 10, tx: hyo.ww * 0.5f, ty: hyo.wh * 0.75f,mirror:true));
            message.hutidorin(sii / 18, hyo.ww * 0.5f, hyo.wh * 0.75f + si / 2, sii, 100, 50, 0, -1, FP.GT("ResetConnect"), hyo: hyo, kazu: 2);

            lis.Add(saw);
            see=message.hutidorin(sii / 18, hyo.ww * 0.5f, hyo.wh * 0.4f + si / 2, sii, 100, 50, 0, -1, FP.GT("GoConnect"), hyo: hyo, kazu: 2);
            foreach (var a in see) a.opa = 0;

            lis.Add(character.onepicturechara("ui\\bubble", si, 10, tx: hyo.ww * 0.75f, ty: hyo.wh * 0.7f));
            message.hutidorin(sii / 18, hyo.ww * 0.75f, hyo.wh * 0.7f + si / 2, sii, 100, 50, 0, -1, FP.GT("BubbleConnect"), hyo: hyo, kazu: 2);
        
            b = new buttoninterface(hyo,1,character.onepicturechara("effects\\sun",si*1.5f),lis,new Charamaker2.Shapes.Circle(0,0));
            si /= 2;
            message.hutidorin(si / 18, hyo.ww * 0.5f, hyo.wh * 0.07f, si, 100, 50, 0, -1, FP.GT("Hyperconnect"), hyo: hyo, kazu: 4);
            si /= 2;
            message.hutidorin(si / 18, hyo.ww * 0.5f, hyo.wh * 0.23f, si, 100, 50, 0, -1, FP.GT("Hyperconnect2"), hyo: hyo, kazu: 4);

        }
        protected override void onstart()
        {
            base.onstart();
            b.start();
        }
        public override void frame(inputin i, float cl)
        {
            base.frame(i, cl);
            b.frame(cl);

            if (i.ok(Keys.W, itype.down)) 
            {
                b.selectsaikinbosi(false, true);
                fileman.playoto("scroll1");
            }
            if (i.ok(Keys.A, itype.down))
            {
                b.selectsaikinbosi(false, false);
                fileman.playoto("scroll1");
            }
            if (i.ok(Keys.S, itype.down))
            {
                b.selectsaikinbosi(true, true);
                fileman.playoto("scroll1");
            }
            if (i.ok(Keys.D, itype.down))
            {
                b.selectsaikinbosi(true, false);
                fileman.playoto("scroll1");
            }
            if (i.ok(Keys.Space, itype.down))
            {
                if (b.selected().Count > 0)
                {
                    superselect(); 
                }
            }
            if (i.ok(Keys.Escape, itype.down))
            {
                end();
            }
            if (i.ok(MouseButtons.Left, itype.down)) 
            {
                var lis=b.clickeds(i.x, i.y);
                if (lis.Count > 0) 
                {
                    if (b.selected().Count > 0 && lis[0] == b.selected()[0])
                    {
                        superselect();
                    }
                    else 
                    {
                        b.select(lis[0]);
                        fileman.playoto("scroll1");
                    }
                }
            }
           
            switch (tu)
            {
                case tusing.no:
                    saw.core.p.texname = "def";
                    foreach (var a in see) a.opa = 0;
                    break;
                case tusing.bogo:
                    saw.core.p.texname = "bogo";
                    saw.core.p.mir = false;
                    foreach (var a in see) a.opa = 1;
                    break;
                case tusing.bubble:
                    saw.core.p.texname = "bubble";
                    saw.core.p.mir = true;
                    foreach (var a in see) a.opa = 1;
                    break;
                default:
                    break;
            }
            supergo(i,hyo);
        }
        player he = null;
        protected void supergo(inputin i,hyojiman hyo) 
        {
           
            if (go)
            {
                saw.core.p.OPA = 1;

                foreach (var a in see) a.text = FP.GT("GoConnect2");
                switch (tu)
                {
                    case tusing.no:
                        supertusin.ends();
                        go = false;
                        fileman.playoto("sippai");
                        break;
                    case tusing.bogo:
                        if (supertusin.cliecon)
                        {

                            i.tag = me;
                            supertusin.cast(i);
                            var ii = supertusin.getinhyoji();
                            if (ii != null)
                            {
                                i.tag = "ok";
                                new clientVS(sm,this).start();
                                fileman.playoto("kettei");
                               go = false;
                            }
                            supertusin.starts();
                        }
                        break;
                    case tusing.bubble:
                        if (supertusin.servcon)
                        {
                            var ii = supertusin.getininput();
                            if (ii != null)
                            {
                                if (ii.tag != "ok")
                                {
                                    he = Sintyokun.getstdplayer("he","enemy\\Bogo");
                                    SD.loadPlayerScript(he, ii.tag);
                                    supertusin.cast(hyo);
                                }
                                else 
                                {

                                    var mee = Sintyokun.getstdplayer("me", "enemy\\Bubble");
                                    SD.loadPlayerScript(mee, me);
                                    new serverVS(sm,mee,he, this).start();
                                    fileman.playoto("kettei");
                                    go = false;

                                }

                            }
                            supertusin.starts();
                        }
                        break;
                    default:
                        break;
                }
               
            }
            else
            {
                saw.core.p.OPA = 0.5f;
                foreach (var a in see) a.text = FP.GT("GoConnect");
            }
        }
        enum tusing
        {
            no,bogo,bubble
        }
        tusing tu = tusing.no;
        bool go = false;
        protected void superselect() 
        {
            fileman.playoto("kettei");
            var lis = b.selected();
            if (lis.Count > 0)
            {
                switch (lis[0].core.p.nowtex)
                {
                    case "ui\\bogo":
                        if (!supertusin.clieon) 
                        {
                            supertusin.setcli();
                        }
                        tu = tusing.bogo;
                        break;

                    case "ui\\bubble":
                        if (!supertusin.servon)
                        {
                            supertusin.setsv();
                        }
                        tu = tusing.bubble;
                        break;

                    case "ui\\battleclear":
                        tu = tusing.no;
                        supertusin.clear();
                        break;
                    default:
                        go = !go;
                        if (go)
                        {
                            supertusin.starts();
                        }
                        else 
                        {
                            supertusin.ends();
                        }
                        break;
                }
            }
        }
    }
    class serverVS : battlebase
    {
        hyojiman hyo2;
        inputin i2=new inputin();
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.05f, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("VS", "serverVS")
                , 0, 0, 0, false, kazu: 4));
        }
        public serverVS(SceneManager sm, player p, player e, Scene next) : base(sm, new List<player> { p }, new List<player> { e })
        {
            hyo2 = fileman.makehyojiman();
            this.next = next;
        }
        protected override void onend()
        {
            base.onend();
            me.remove();
            he.remove();
            supertusin.ends();
        }

        float endtimer = 180;
        public override void frame(inputin i, float cl)
        {
            var iii = supertusin.getininput();
            if (iii != null)
            {
                i2.tusininput(iii);
                gogotokei(cl);
                if (me.c.gettx() < he.c.gettx())
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
                    if (!z.onhani(me.c.gettx(), me.c.getty()))
                    {
                        me.c.settxy(z.gettx(), z.getty());
                    }
                    if (!z.onhani(he.c.gettx(), he.c.getty()))
                    {
                        he.c.settxy(z.gettx(), z.getty());
                    }

                    //   z.drawshape(hyo, 1, 0, 0, 1, true);
                }

                

                hyo2.copy(hyo);
                me.UIn(i, hyo, cl);
                he.UIn(i2, hyo2, cl);
                hyo2.nisehyoji(cl);
                supertusin.cast(hyo2);
                baseframe(i, cl);
                cameran333(1);
            }
            if (!supertusin.servcon||i.ok(Keys.Escape,itype.down))
            {
                end();
            }
        }
    }
    class clientVS : Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.05f, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("VS", "clientVS")
                , 0, 0, 0, false, kazu: 4));
        }
        public clientVS(SceneManager sm, Scene next) : base(sm)
        {
            this.next = next;
        }

        public override void frame(inputin i, float cl)
        {
            var hhh = supertusin.getinhyoji();
            if(hhh!=null)
            {
                hyo.tusinhyoji(hhh);
                base.frame(i,cl);
            }
            if (!supertusin.cliecon || i.ok(Keys.Escape, itype.down)) 
            {
                end();
            }
            
            i.tag = "ok";
            supertusin.cast(i);

        }
        public override void end()
        {
            base.end();
            supertusin.ends();
        }
    }
    class shop : Scene 
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.00f, hyo.camy + hyo.wh * 0.00f, si, 99999999, 0, 0, -1,
                getHelpstring("shop")
                , 0, 0, 0, false, kazu: 4));
        }
        public shop(SceneManager sm,Scene next) : base(sm) 
        {
            this.next = next;
            picture.onetexpic("ui\\gold",hyo.ww/10,-100,false,tx: hyo.ww / 2, ty:hyo.wh*0.5f).add(hyo);
        }
        protected override void onstart()
        {
            reset();
            float si = hyo.ww /7;
            var sss = message.hutidorin(si/20,hyo.ww/2,hyo.wh/2-si,si,100,50,0,45,FP.GT("Shop"),0,0,0,true,hyo:hyo);
            foreach (var a in sss) 
            {
                a.setfadeout(0, 45);
            }
            base.onstart();
        }
        List<itemcard> cards = new List<itemcard>();
        
        protected void reset() 
        {
            foreach (var a in cards) a.sinu(hyo);
            cards.Clear();
            var ss = SD.S.getupgrade();
            var lis = ss.Upgradecards;
            for (int i=0;i<lis.Count;i++) 
            {
                var c = new itemcard(hyo.ww *0.18f, lis[i],1.0f);
                c.settxy(hyo.ww*(i%5+0.7f)/5.3f,hyo.wh*(1f+(int)(i/5)*2)/4);
                c.resethyoji(hyo);
                cards.Add(c);
                
            }
        }
        public override void frame(inputin i, float cl)
        {
            base.frame(i, cl);
            foreach (var a in cards) a.frame(cl);
            {
                float si = hyo.ww / 25;
                message.hutidorin(si/15,hyo.ww / 2, hyo.wh*0.5f-si/2, si,100,50,0,cl,FP.GT("SSsyojikin",null,SD.S.gold),kyoutyousuru:false,hyo:hyo);
            }
            if (i.ok(MouseButtons.Left, itype.down))
            {
                bool resett = false;
                foreach (var a in cards)
                {
                    if (a.on(i))
                    {
                        if (a.getcard(null, SD.S))
                        {
                            fileman.playoto("kettei");
                            resett = true;
                            
                        }
                        else
                        {
                            fileman.playoto("TB\\buu");
                        }
                    }
                }
                if(resett) reset();
            }
            else if (i.ok(MouseButtons.Right, itype.down))
            {
                bool resett = false;
                foreach (var a in cards)
                {
                    if (a.on(i))
                    {
                        if (a.GetUpgradecard().goodbye(SD.S))
                        {
                            fileman.playoto("TB\\jarin");
                            resett = true;

                        }
                        else
                        {
                            fileman.playoto("TB\\buu");
                        }
                    }
                }
                if (resett) reset();
            }
            if (i.ok(Keys.Escape, itype.down)) 
            {
                fileman.playoto("kettei");
                end();
            }
           


        }

    }
    
}
