using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Charamaker2;
using Charamaker2.Character;
using Charamaker2.input;
using Charamaker2.Shapes;
using GameSet1;
using GameSet1.benriUI;
using THE_Tournament.scene;

namespace THE_Tournament.scene
{
    class bossselect:Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.05f, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("bossselect")
                , 0, 0, 0, false, kazu: 4));
        }
       public static List<string> getbosees()
        {
            var res = new List<string>();
            var add=FP.loadtext("texts\\bosses");
         
            var lis=new List<string>(add.Split('\n'));
            int starts = 0;
            for (int i = 0; i < lis.Count; i++) 
            {
                if (lis[i]== "sepalate!")
                {
                    string say = "";
                    for (int t = starts; t < i; t++) 
                    {
                        say += lis[t] + "\n";
                    }
                    res.Add(say);
                    starts = i + 1;
                }
            }

            return res;
        }
        List<string> names = new List<string>();
        List<player> bosses = new List<player>();
        rolling r;
        public bossselect(SceneManager sm,Scene next) : base(sm,next) 
        {
       
            hyo.bairitu = 2;
            
            float si = hyo.ww / 20;
            bossname = message.hutidorin(si/18,hyo.ww*0.5f,hyo.wh*0.22f,si,100,50,0,-1,"",hyo:hyo,kazu:4);
            picture.onetexpic("ui\\bossselect", hyo.ww * 0.2f, -1000,false, 0.5f,0.35f,tx: hyo.ww * 0.5f, ty: hyo.wh * 0.20f).add(hyo);
         

        }
        protected override void onstart()
        {
            base.onstart();
            SD.savesave<SD>();
            var lis = getbosees();
            var charas = new List<character>();
            var weps = new List<character>();
            {
                int i = SD.S.bossdare % lis.Count;
                {
                    var st = lis[i].Split('\n');
                    var stt = st[0];

                    var so = stt.Split(',');

                    names.Add(so[0]);
                    var enemy = Sintyokun.getstdplayer("he", so[1],1.75f);

                    var seis = lis[i].Replace(stt + "\n", "");

                    SD.loadPlayerScript(enemy, seis);
                    float bai = Math.Max(SD.S.bosslevel - 1,0);
                    enemy.s.influte(null, new PlayerStatus(enemy.s.mhel * bai, enemy.s.mspeed * bai, enemy.s.mdam * bai, enemy.s.mcool * bai
                        , enemy.s.mskill * bai, enemy.s.mjizoku * bai, enemy.s.msize * bai), true);
                    bosses.Add(enemy);
                    charas.Add(enemy.c);
                    enemy.c.settxy(hyo.ww / 2 + hyo.ww / 4 * (int)(0), hyo.wh * 0.5f);
                    foreach (var a in enemy.WS)
                    {
                        if (a.wep != null)
                        {
                            a.soroewep();
                            weps.Add(a.wep.c);
                        }
                    }
                }
            }
            r = new rolling(hyo, 0, 20, charas, new Circle(0, 0), weps);
            r.start();
            idoued();
        }
       
        public override void frame(inputin i, float cl)
        {
            base.frame(i, cl);
            r.frame(cl);
            if (r.nowidx >= 0)
            {
                bosses[r.nowidx].UIn(i, hyo, cl, false);
                float size = hyo.ww / 60;

                string text = FP.GT("SSurine", null, bosses[r.nowidx].fase) + "\n" + bosses[r.nowidx].s.printstatus(false);
                foreach (var a in bosses[r.nowidx].WS)
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
                if (r.idou(1))
                {
                    idoued();
                }
            }
            if (i.ok(Keys.A, itype.ing))
            {
                if (r.idou(-1)) 
                {
                    idoued();
                }
            }
            if (i.ok(MouseButtons.Left, itype.down))
            {
                var s = r.clickeds(i.x, i.y);
                if (s.Count > 0)
                {
                    if (r.idou(s[0])) hyo.playoto("scroll1");
                }
            }
            if (i.ok(Keys.Escape, itype.down))
            {
                end();
            }
            if (i.ok(Keys.Space, itype.down)) 
            {
                if (SD.S.getPlayerScripts().Count > 0)
                {
                    var enes = new List<player>();
                    enes.Add(bosses[r.nowidx]);
                    next = new bossjyunbi(enes, bosses[r.nowidx].fase, sm, new bossselect(sm, this.next));
                    fileman.playoto("kettei");
                    end();
                }
                else 
                {
                    fileman.playoto("TB\\buu"); 
                }
            }
        }
        protected override void onend()
        {
            base.onend();
            r.end();
        }
        List<message> bossname;
        protected void idoued() 
        {
            hyo.playoto("scroll1");
            foreach (var a in bossname) 
            {
                a.text = names[r.nowidx]+"*"+SD.S.bosslevel.ToString()+"/"+bosses[r.nowidx].fase;

            }
        }
    }
    class bossjyunbi: Scene
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("bossjyunbi")
                , 0, 0, 0, false, kazu: 4));
        }
        List<message> m;
        List<player> ps;
        GameSet1.benriUI.rolling r;
        int kazu;
        List<player> enes;
        public bossjyunbi(List<player>enes,int maxselect,SceneManager sm, Scene next) : base(sm)
        {
            kazu = maxselect;
            hyo.bairitu *= 1.5f;
            float si = hyo.ww / 10;
            this.enes = enes;
            this.next = next;
            ps = SD.S.goallPlayerScript();
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
            si /= 2;
            m=message.hutidorin(si / 18, hyo.ww * 0.5f, hyo.wh * 0.22f, si, 100, 50, 0, -1, FP.GT("Bossjyunbi",null,kazu), hyo: hyo, kazu: 4);
            picture.onetexpic("ui\\bossselect", hyo.ww * 0.2f, -10000, false, 0.5f, 0.35f, tx: hyo.ww * 0.5f, ty: hyo.wh * 0.20f).add(hyo);

            new picture(hyo.ww / 2 - 50, hyo.wh * 0.0f, -1000, 100, hyo.wh, 50, 0, 0, false, 0.3f, "def", new Dictionary<string, string> { { "def", "pinkbit" } }).add(hyo);

            r = new GameSet1.benriUI.rolling(hyo, ps.Count / 2, 10, lis, new Circle(0, 0), adds);
        }
        protected override void onstart()
        {
            r.start();
           
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
                if (markes.Count > 0)
                {
                    List<player> mes = new List<player>();
                    foreach (var a in markes)
                    {
                        mes.Add(ps[a]);
                    }
                    fileman.playoto("kettei");
                    next = new bossVS(sm, mes, enes, this.next);
                    end();
                }
                else 
                {
                    fileman.playoto("TB\\buu");
                }
            }
            if (i.ok(Keys.Escape, itype.down))
            {
                end();
            }
            else if (i.ok(Keys.T, itype.down))
            {
                fileman.playoto("kettei");
                mark();

            }
           



            r.frame(cl);
            base.frame(i, cl);

        }
        protected override void onend()
        {
            r.end();
            base.onend();
        }


        List<character> markers = new List<character>();
        List<int> markes = new List<int>();
        protected void markkaijo()
        {
            var idx = markes.IndexOf(r.nowidx);
            if (idx>=0)
            {
                var marker = markers[idx];
                r.adds.Remove(marker);
                marker.sinu(hyo);
                markers.Remove(marker);
                markes.RemoveAt(idx);
                fileman.playoto("sippai");
                foreach (var a in m)
                {
                    a.text = FP.GT("Bossjyunbi", null, kazu - markes.Count);
                }
            }
        }
        protected void mark()
        {
            if (r.selected().Count == 0) return;
            var sel = r.selected()[0];
            if (!markes.Contains(r.nowidx))
            {
                if (markes.Count < kazu)
                {
                    var marker = character.onepicturechara("sun", 64, -10);
                    marker.settxy(sel.gettx(), sel.getty());
                    r.adds.Add(marker);
                    marker.resethyoji(hyo);
                    markes.Add(r.nowidx);
                    markers.Add(marker);
                    fileman.playoto("kettei");
                    foreach (var a in m) 
                    {
                        a.text = FP.GT("Bossjyunbi", null, kazu - markes.Count);
                    }
                }
                else{ fileman.playoto("TB\\buu"); }
            }
            else 
            {
                markkaijo();
            }
            
        }
    }
    class bossVS : battlebase
    {
        protected override void makehelps(List<message> help)
        {
            float si = hyo.ww / 50;

            help.AddRange(message.hutidorin(si / 15
                , hyo.camx + hyo.ww * 0.05f, hyo.camy + hyo.wh * 0.25f, si, 99999999, 0, 0, -1,
                getHelpstring("VS", "bossVS")
                , 0, 0, 0, false, kazu: 4));
        }
        public bossVS(SceneManager sm, List<player> p, List<player> e, Scene next) : base(sm, p, e)
        {
            this.next = next;
        }
        protected override void onstart()
        {
            base.onstart();
            foreach (var a in this.hes) a.autoskill = true;
            for (int i=1;i<mes.Count;i++ ) mes[i].autoskill = true;

        }

        float endtimer = 180;
        public override void frame(inputin i, float cl)
        {
            cl = gogotokei(cl);

        
            if (!me.onEM || !he.onEM)
            {
                if (endtimer > 0) { endtimer -= cl; }
                else
                {
                    end();
                }
            }
            //  Console.WriteLine(me.c.gettx()+ " asdaj " + he.c.gettx() + " asklfa " + WW);
            base.frame(i, cl);

        }
        protected override void onend()
        {
            if (!he.onEM)
            {
                SD.S.bosslevel += 0.1f;
            }
            else 
            {
                SD.S.bosslevel = Math.Max(1,SD.S.bosslevel-0.1f);
            }
            SD.S.bossdare = fileman.r.Next()%bossselect.getbosees().Count;
        }

    }
}
