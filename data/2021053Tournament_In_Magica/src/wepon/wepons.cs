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
using THE_Tournament.waza;

namespace THE_Tournament.wepon
{

    class timarm : Wepon
    {
        public timarm(Weponstatus s) : base(s, character.onepicturechara("weps\\timpunch", 12, 1, false, 0.5f, 0.1f)
            , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {

        }
        protected override void attack()
        {

            base.attack();
            var a = new tackle(p, s.Tdam, s.Z, s.Tjizoku, this.c, "core", new Rectangle(0, 0));

            this.c.addmotion(new idouman(s.Tjizoku, 0, 0, 15));


            var m = new motion();
            m.addmoves(new Kscalechangeman(10, "", s.Tsize, s.Tsize, 0, true, true, true));
            m.addmoves(new moveman(s.Tjizoku - 10, true));
            m.addmoves(new Kscalechangeman(10, "", -s.Tsize, -s.Tsize, 0, true, true, true));

            a.removed += (object sender, EEventArgs e) =>
            {
                m.frame(this.c, Math.Max(a.nokori - 10, 0));


                this.c.addmotion(new idouman(a.nokori, 0, 0, -15));
            };


            this.c.addmotion(m);
            EEV.Sentitymaked(this, a.tok);
        }
        protected override void skill(inputin i)
        {
            base.skill(i);

            var a = new tackle(p, s.Tdam * 1.5f, s.Z, s.Tjizoku * 1.5f, this.c, "core", new Rectangle(0, 0));

            this.c.addmotion(new idouman(s.Tjizoku * 1.5f, 0, 0, 15));


            var m = new motion();
            m.addmoves(new Kscalechangeman(10, "", s.Tsize, s.Tsize, 0, true, true, true));
            m.addmoves(new moveman(s.Tjizoku * 1.5f - 10, true));
            m.addmoves(new Kscalechangeman(10, "", -s.Tsize, -s.Tsize, 0, true, true, true));

            a.removed += (object sender, EEventArgs e) =>
            {
                m.frame(this.c, Math.Max(a.nokori - 10, 0));


                this.c.addmotion(new idouman(a.nokori, 0, 0, -15));
            };
            this.c.addmotion(m);
            EEV.Sentitymaked(this, a.tok);
        }
    }

    class timshot : Wepon
    {
        public timshot(Weponstatus s) : base(s, character.onepicturechara("weps\\timshot", 12, 1, false, 0.5f, 0.1f)
            , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {

        }
        protected override void attack()
        {
            base.attack();
            var bullet = new Sentity(new status(s.Tdam, s.Z), fileman.loadcharacter("timkobusi")
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0.01f, 0, 0, 0, 0, 0, 1, new List<string>(p.bif.atag)));


            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            new danganka(bullet, s.Tjizoku);
            new jisatukun2(s.Tjizoku, -90).add(bullet);
            bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize, s.Tsize, 0, true, true));
            bullet.add(EM);
            EM.hyoji.playoto("firehassya");

            float speed = 20;
            double kaku = 0;
            foreach (var a in p.tag)
            {
                kaku = FP.entitysimulate<Entity>(bullet, a.c.gettx(), a.c.getty(), speed, s.Tjizoku, 2, 5);
                break;
            }
            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);
        }



        protected override void skill(inputin i)
        {
            base.skill(i);

            double k = this.p.Acore.nasukaku(i.x, i.y);

            var bullet = new Sentity(new status(s.Tdam * 2, s.Z), fileman.loadcharacter("timkobusi")
               , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
               , new buturiinfo(1, 0.01f, 0, 0, 0, 0, 0, 1, new List<string>(p.bif.atag)));


            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            new danganka(bullet, s.Tjizoku * 1.2f);
            new jisatukun2(s.Tjizoku * 1.2f, -90).add(bullet);

            bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize * 1.5f, s.Tsize * 1.5f, 0, true, true));
            bullet.add(EM);
            EM.hyoji.playoto("firehassya");

            float speed = 20 * 1.5f;
            double kaku = k;
            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);
        }
    }
    class firerod : Wepon
    {
        public firerod(Weponstatus s) : base(s, character.onepicturechara("weps\\firerod", 12, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var bullet = new Sentity(new status(s.Tdam, s.Z), character.onepicturechara("effects\\fireball", 12, 100, opa: 0.8f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            new danganka(bullet, s.Tjizoku, "firehit", 0.5f, 0.3f, 0, 10);


            new jisatukun2(s.Tjizoku).add(bullet);




            bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize, s.Tsize, 0, true, true));
            bullet.add(EM);
            EM.hyoji.playoto("firefosa");

            float speed = 5;
            double kaku = 0;
            foreach (var a in p.tag)
            {
                kaku = Math.Atan2(-bullet.c.getty() + a.c.getty(), -bullet.c.gettx() + a.c.gettx());
                break;
            }
            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                bullet.c.addmotion(new idouman(s.Tjizoku, 0, 0, 10));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                bullet.c.addmotion(new idouman(s.Tjizoku, 0, 0, -10));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);
        }



        protected override void skill(inputin i)
        {
            base.skill(i);

            double k = this.p.Acore.nasukaku(i.x, i.y);

            var bullet = new Sentity(new status(s.Tdam * 2, s.Z), character.onepicturechara("effects\\fireball", 12, 100, opa: 0.8f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));


            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            new danganka(bullet, s.Tjizoku * 1.2f, "firehit", 0.5f, 0.3f, 0, 10);
            new jisatukun2(s.Tjizoku * 1.2f).add(bullet);



            bullet.c.addmotion(new Kscalechangeman(10 * 1.5f, "", s.Tsize * 1.5f, s.Tsize * 1.5f, 0, true, true));
            bullet.add(EM);
            EM.hyoji.playoto("firefosa");

            float speed = 5;
            double kaku = k;
            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                bullet.c.addmotion(new idouman(s.Tjizoku * 1.2f, 0, 0, 10));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                bullet.c.addmotion(new idouman(s.Tjizoku * 1.2f, 0, 0, -10));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);

        }
    }
    class icerod : Wepon
    {
        public icerod(Weponstatus s) : base(s, character.onepicturechara("weps\\icerod", 12, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.ice });
        }
        protected override void attack()
        {
            base.attack();
            double kaku = 66666;
            EM.hyoji.playoto("icegangan");
            for (int i = -1; i <= 1; i++)
            {
                var cc = character.onepicturechara("effects\\hyokaiblock", 12, 100, opa: 0.8f);
                var bullet = new Sentity(new status(s.Tdam, s.Z), cc
                    , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
                    , new buturiinfo(10, 0, 0.0f, 0, 0, 0, 0, 0.3f, new List<string>(p.bif.atag)));



                bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));



                var d = new danganka(bullet, s.Tjizoku, "icehit");
                new jisatukun2(s.Tjizoku, 0).add(bullet);

                d.framed += (sender, eev) =>
                {
                    var ss = (Waza)sender;
                    if (ss.atarislist(666).Count == 0)
                    {
                        var lis = EM.overweights;
                        Waza.atypefilter(lis, ss.e.bif);
                        Waza.atafilter(lis, null, ss.e, null, false);
                        ss.atarisAddRange(lis, ss.end, 666);
                    }
                    else
                    {
                        ss.e.bif.teikou = 1;
                        ss.e.bif.ax = 0;
                        ss.e.bif.ay = 0;
                        ss.e.bif.vx = 0;
                        ss.e.bif.vy = 0;
                    }
                };


                bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize, s.Tsize, 0, true, true));
                bullet.add(EM);


                float speed = 12;


                if (kaku == 66666)
                {
                    foreach (var a in p.tag)
                    {
                        kaku = Math.Atan2(-bullet.c.getty() + a.c.getty(), -bullet.c.gettx() + a.c.gettx());
                        break;
                    }
                }
                if (c.mirror)
                {
                    this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                    bullet.c.addmotion(new idouman(s.Tjizoku, 0, 0, 4));
                }
                else
                {
                    this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                    bullet.c.addmotion(new idouman(s.Tjizoku, 0, 0, -4));
                }
                bullet.bif.kasoku(speed * (float)Math.Cos(kaku + Math.PI / 10 * i), speed * (float)Math.Sin(kaku + Math.PI / 10 * i));
                EEV.Sentitymaked(this, bullet);
            }
        }



        protected override void skill(inputin i)
        {
            base.skill(i);

            double k = this.p.Acore.nasukaku(i.x, i.y);

            double kaku = k;
            EM.hyoji.playoto("icegangan");
            for (int j = -3; j <= 2; j++)
            {


                var cc = character.onepicturechara("effects\\hyokaiblock", 12, 100, opa: 0.8f);
                var bullet = new Sentity(new status(s.Tdam, s.Z), cc
                    , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
                    , new buturiinfo(10, 0, 0.0f, 0, 0, 0, 0, 0.3f, new List<string>(p.bif.atag)));



                bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

                var d = new danganka(bullet, s.Tjizoku * 1.5f, "icehit");
                new jisatukun2(s.Tjizoku * 1.5f, 0).add(bullet);

                d.framed += (sender, eev) =>
                {
                    var ss = (Waza)sender;
                    if (ss.atarislist(666).Count == 0)
                    {

                        var lis = EM.overweights;

                        Waza.atypefilter(lis, ss.e.bif);
                        Waza.atafilter(lis, null, ss.e, null, false);
                        ss.atarisAddRange(lis, ss.end, 666);
                    }
                    else
                    {

                        ss.e.bif.teikou = 1;
                        ss.e.bif.ax = 0;
                        ss.e.bif.ay = 0;
                        ss.e.bif.vx = 0;
                        ss.e.bif.vy = 0;
                    }
                };


                bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize, s.Tsize, 0, true, true));
                bullet.add(EM);


                float speed = 12;


                if (kaku == 66666)
                {
                    foreach (var a in p.tag)
                    {
                        kaku = Math.Atan2(-bullet.c.getty() + a.c.getty(), -bullet.c.gettx() + a.c.gettx());
                        break;
                    }
                }
                if (c.mirror)
                {
                    this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                    bullet.c.addmotion(new idouman(s.Tjizoku * 1.5f, 0, 0, 4));
                }
                else
                {
                    this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                    bullet.c.addmotion(new idouman(s.Tjizoku * 1.5f, 0, 0, -4));
                }
                bullet.bif.kasoku(speed * (float)Math.Cos(kaku + Math.PI / 13 * j), speed * (float)Math.Sin(kaku + Math.PI / 13 * j));
                EEV.Sentitymaked(this, bullet);
            }
        }
    }
    class thunderrod : Wepon
    {
        public thunderrod(Weponstatus s) : base(s, character.onepicturechara("weps\\thunderrod", 12, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.thunder, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var bullet = new Sentity(new status(s.Tdam, s.Z), character.onepicturechara("effects\\thunderbolt", 12, 100, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));
            {
                var ho = new motion(new texpropman(1, "", 471, 0));
                ho.start(bullet.c);
                ho.frame(bullet.c, 10);
            }
            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            var w = new Waza(13);
            w.add(bullet);
            w.removed += (a, b) =>
              {
                  var d = new danganka(bullet, s.Tjizoku, "thunderhit", 0.8f, 0.8f, 0.1f, -1);

                  new jisatukun2(s.Tjizoku).add(bullet);
              };

            var m = new motion();
            m.addmoves(new Kscalechangeman(13, "", s.Tsize, s.Tsize, 0, true, true));
            m.addmoves(new texpropman(13, "", 471, 0.8f));
            bullet.add(EM);

            double kaku = 0;
            foreach (var a in p.tag)
            {
                float hitritu = fileman.whrandhani(1000) / 100f;
                kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hitritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hitritu);
                bullet.c.settxy(a.c.gettx() + a.bif.vx * hitritu, a.c.getty() + a.bif.vy * hitritu);
                break;
            }

            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                m.addmoves(new idouman(s.Tjizoku + 13, 0, 0, 30));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                m.addmoves(new idouman(s.Tjizoku + 13, 0, 0, -30));
            }
            bullet.c.addmotion(m);
            EEV.Sentitymaked(this, bullet);
        }



        protected override void skill(inputin i)
        {
            base.skill(i);
            var bullet = new Sentity(new status(s.Tdam * 2, s.Z), character.onepicturechara("effects\\thunderbolt", 12, 100, opa: 1f)
               , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
               , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));
            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            var w = new Waza(13);
            w.add(bullet);
            w.removed += (a, b) =>
            {
                new danganka(bullet, s.Tjizoku * 1.5f, "thunderhit", 0.8f, 0.8f, 0.1f, -1);
                new jisatukun2(s.Tjizoku * 1.5f).add(bullet);
            };

            var m = new motion();
            m.addmoves(new Kscalechangeman(13, "", s.Tsize * 1.5f, s.Tsize * 1.5f, 0, true, true));
            m.addmoves(new texpropman(13, "", 471, 0.8f));
            bullet.add(EM);

            double kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
            bullet.c.settxy(i.x, i.y);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                m.addmoves(new idouman(s.Tjizoku * 1.5f + 13, 0, 0, 30));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                m.addmoves(new idouman(s.Tjizoku * 1.5f + 13, 0, 0, -30));
            }
            bullet.c.addmotion(m);
            EEV.Sentitymaked(this, bullet);
        }
    }
    class windrod : Wepon
    {
        public windrod(Weponstatus s) : base(s, character.onepicturechara("weps\\windrod", 12, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.wind, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var bullet = new Sentity(new status(s.Tdam, s.Z), character.onepicturechara("effects\\windbit", 12, 100, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
                , new buturiinfo(1, 0.001f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            double kaku = 0;
            Entity tag = null;
            foreach (var a in p.tag)
            {
                tag = a;
                kaku = Math.Atan2(-bullet.c.getty() + a.c.getty(), -bullet.c.gettx() + a.c.gettx());
                break;
            }

            var d = new danganka(bullet, s.Tjizoku, "windhit", 0.7f, 0.6f, 0.1f, -1);
            if (tag != null)
                d.framed += (send, arg) =>
                {
                    if (!((Waza)send).atarisAru(tag))
                    {
                        var kkk = Math.Atan2(tag.c.getty() - arg.ent.c.getty(), tag.c.gettx() - arg.ent.c.gettx());
                        arg.ent.bif.kasoku(arg.ent, 1 * (float)Math.Cos(kkk), 1 * (float)Math.Sin(kkk), -1, arg.cl);
                    }
                    else
                    {
                        arg.ent.bif.teikou = 0;
                    }
                };
            new jisatukun2(s.Tjizoku, 0, true).add(bullet);



            var m = new motion();
            m.addmoves(new Kscalechangeman(20, "", s.Tsize, s.Tsize, 0, true, true));
            bullet.add(EM);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }
            bullet.c.addmotion(m);

            EEV.Sentitymaked(this, bullet);
        }



        protected override void skill(inputin i)
        {
            base.skill(i);
            var bullet = new Sentity(new status(s.Tdam * 2, s.Z), character.onepicturechara("effects\\windbit", 12, 100, opa: 1f)
               , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
               , new buturiinfo(1, 0.001f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            double kaku = 0;
            Entity tag = null;
            foreach (var a in p.tag)
            {
                tag = a;

                break;
            }
            kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.y);

            var d = new danganka(bullet, s.Tjizoku * 1.5f, "windhit", 0.7f, 0.6f, 0.1f, -1);
            if (tag != null)
                d.framed += (send, arg) =>
                {
                    if (!((Waza)send).atarisAru(tag))
                    {
                        var kkk = Math.Atan2(tag.c.getty() - arg.ent.c.getty(), tag.c.gettx() - arg.ent.c.gettx());
                        arg.ent.bif.kasoku(arg.ent, 1 * (float)Math.Cos(kkk), 1 * (float)Math.Sin(kkk), -1, arg.cl);
                    }
                    else
                    {
                        arg.ent.bif.teikou = 0;
                    }
                };
            new jisatukun2(s.Tjizoku * 1.5f, 0, true).add(bullet);



            var m = new motion();
            m.addmoves(new Kscalechangeman(20, "", s.Tsize * 1.5f, s.Tsize * 1.5f, 0, true, true));
            bullet.add(EM);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }
            bullet.c.addmotion(m);

            EEV.Sentitymaked(this, bullet);
        }
    }
    class earthrod : Wepon
    {
        public earthrod(Weponstatus s) : base(s, character.onepicturechara("weps\\earthrod", 12, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.earth });
        }
        protected override void attack()
        {
            base.attack();
            var bullet = new Sentity(new status(s.Tdam, s.Z), character.onepicturechara("tikei\\grass", 12 * s.Tsize, 100, false, 0.5f, 0.95f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) })
                , new buturiinfo(1, 0.001f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            double kaku = 0;
            Entity tag = null;
            foreach (var a in p.tag)
            {
                tag = a;
                float hitritu = fileman.whrandhani(1000) / 100f;
                kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hitritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hitritu);

                bullet.c.settxy(tag.c.gettx() + tag.bif.vx * hitritu, tag.c.getty());

                break;
            }
            {
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, -10000, "", -1);
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, 40000, "", -1);
            }

            var ww = new Waza(20);
            ww.add(bullet);
            ww.removed += (a, b) =>
            {
                var d = new danganka(bullet, 10, "earthhit", 1f, 0.5f, 0, -1);
                bullet.c.addmotion(new Kscalechangeman(5, "", 0, 2, 0, true, true));
            };

            new jisatukun2(s.Tjizoku + 20, 0, true).add(bullet);





            bullet.add(EM);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }

            EEV.Sentitymaked(this, bullet);
        }



        protected override void skill(inputin i)
        {
            base.skill(i);
            var bullet = new Sentity(new status(s.Tdam * 2, s.Z), character.onepicturechara("tikei\\grass", 12 * s.Tsize * 1.5f, 100, false, 0.5f, 0.95f, opa: 1f)
                 , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) })
                 , new buturiinfo(1, 0.001f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            double kaku = 0;

            kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);


            bullet.c.settxy(i.x, i.y);
            {
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, -10000, "", -1);
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, 40000, "", -1);
            }


            var ww = new Waza(20);
            ww.add(bullet);
            ww.removed += (a, b) =>
            {
                var d = new danganka(bullet, 10, "earthhit", 1f, 0.5f, 0, -1);
                bullet.c.addmotion(new Kscalechangeman(5, "", 0, 2, 0, true, true));
            };

            new jisatukun2(s.Tjizoku * 1.5f + 20, 0, true).add(bullet);




            bullet.add(EM);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }


            EEV.Sentitymaked(this, bullet);
        }
    }
    class lightrod : Wepon
    {
        public lightrod(Weponstatus s) : base(s, character.onepicturechara("weps\\lightrod", 12, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.light, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var bullet = new Sentity(new status(s.Tdam, s.Z), character.onepicturechara("effects\\lightshield", 12, 100, opa: 0.8f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            var dan = new danganka(bullet, s.Tjizoku, "lighthit", 0.5f, 0.5f, 0.1f);
            new jisatukun2(s.Tjizoku, 0).add(bullet);
            dan.framed += (sender, arg) =>
              {
                  var send = (Waza)sender;
                  var lis = EM.atarerus;

                  var lis2 = EM.overweights;

                  Waza.listfilter(lis, lis2);

                  Waza.atypefilter(lis, bullet.bif);
                //atarisfilter(lis,2);
                Waza.atafilter(lis, new List<string> { "" }, bullet, null, false);
                  var s = bullet.ab.getatari("core");
                  var ps = bullet.pab.getatari("core");
                  var rad = Math.Atan2(bullet.bif.vy, bullet.bif.vx);
                  foreach (var a in lis)
                  {
                    //atarisAdd(a,0,2);
                    var kou = a.Acore.gethosen(ps.gettx(), ps.getty());

                      var aas = Math.Atan2(Math.Sin(rad - (kou + Math.PI)), Math.Cos(rad - (kou + Math.PI)));
                    // Console.WriteLine(kou / Math.PI * 180 + "  " + aas / Math.PI * 180 + "   " + rad / Math.PI * 180);
                    if (Math.Abs(aas) < Math.PI / 2)
                      {
                          rad = Math.Atan2(Math.Sin(kou - aas), Math.Cos(kou - aas));
                        //    Console.WriteLine(kou / Math.PI * 180 + " :: " + aas / Math.PI * 180 + "  :: " + rad / Math.PI * 180);
                        var sum = (float)Math.Sqrt(bullet.bif.vx * bullet.bif.vx + bullet.bif.vy * bullet.bif.vy);
                          bullet.bif.vx = sum * (float)Math.Cos(rad);
                          bullet.bif.vy = sum * (float)Math.Sin(rad);
                      }

                  }
              };


            bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize * 2, s.Tsize, 0, true, true));
            bullet.add(EM);
            EM.hyoji.playoto("lighthassya");

            float speed = 15;
            double kaku = 0;
            foreach (var a in p.tag)
            {
                kaku = Math.Atan2(-bullet.c.getty() + a.c.getty(), -bullet.c.gettx() + a.c.gettx());
                break;
            }
            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);
        }



        protected override void skill(inputin i)
        {
            base.skill(i);

            double k = this.p.Acore.nasukaku(i.x, i.y);
            var bullet = new Sentity(new status(s.Tdam * 2, s.Z), character.onepicturechara("effects\\lightshield", 12, 100, opa: 0.8f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            var dan = new danganka(bullet, s.Tjizoku * 1.5f, "lighthit", 0.5f, 0.5f, 0.1f);
            new jisatukun2(s.Tjizoku * 1.5f, 0).add(bullet);
            dan.framed += (sender, arg) =>
            {
                var send = (Waza)sender;
                var lis = EM.atarerus;

                var lis2 = EM.overweights;

                Waza.listfilter(lis, lis2);

                Waza.atypefilter(lis, bullet.bif);
                //atarisfilter(lis,2);
                Waza.atafilter(lis, new List<string> { "" }, bullet, null, false);
                var s = bullet.ab.getatari("core");
                var ps = bullet.pab.getatari("core");
                var rad = Math.Atan2(bullet.bif.vy, bullet.bif.vx);
                foreach (var a in lis)
                {
                    //atarisAdd(a,0,2);
                    var kou = a.Acore.gethosen(ps.gettx(), ps.getty());

                    var aas = Math.Atan2(Math.Sin(rad - (kou + Math.PI)), Math.Cos(rad - (kou + Math.PI)));
                    // Console.WriteLine(kou / Math.PI * 180 + "  " + aas / Math.PI * 180 + "   " + rad / Math.PI * 180);
                    if (Math.Abs(aas) < Math.PI / 2)
                    {
                        rad = Math.Atan2(Math.Sin(kou - aas), Math.Cos(kou - aas));
                        //    Console.WriteLine(kou / Math.PI * 180 + " :: " + aas / Math.PI * 180 + "  :: " + rad / Math.PI * 180);
                        var sum = (float)Math.Sqrt(bullet.bif.vx * bullet.bif.vx + bullet.bif.vy * bullet.bif.vy);
                        bullet.bif.vx = sum * (float)Math.Cos(rad);
                        bullet.bif.vy = sum * (float)Math.Sin(rad);


                    }

                }
            };


            bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize * 2 * 1.5f, s.Tsize * 1.5f, 0, true, true));
            bullet.add(EM);
            EM.hyoji.playoto("lighthassya");

            float speed = 15;
            double kaku = k;
            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);

        }
    }

    class darkrod : Wepon
    {
        public darkrod(Weponstatus s) : base(s, character.onepicturechara("weps\\darkrod", 12, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.dark, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var bullet = new Sentity(new status(s.Tdam, s.Z), character.onepicturechara("effects\\darkball", 12, 100, false, 0.95f, 0.5f, opa: 0.8f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            var dan = new danganka(bullet, s.Tjizoku, "darkhit");
            new jisatukun2(s.Tjizoku).add(bullet);



            bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize, s.Tsize, 0, true, true));
            bullet.add(EM);

            float speed = 8;
            double kaku = 0;
            foreach (var a in p.tag)
            {
                kaku = Math.Atan2(-bullet.c.getty() + a.c.getty(), -bullet.c.gettx() + a.c.gettx());
                break;
            }
            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                bullet.c.addmotion(new idouman(s.Tjizoku, 0, 0, 33));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                bullet.c.addmotion(new idouman(s.Tjizoku, 0, 0, -33));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);
        }



        protected override void skill(inputin i)
        {
            base.skill(i);

            double k = this.p.Acore.nasukaku(i.x, i.y);

            var bullet = new Sentity(new status(s.Tdam * 2, s.Z), character.onepicturechara("effects\\darkball", 12, 100, false, 0.95f, 0.5f, opa: 0.8f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            var dan = new danganka(bullet, s.Tjizoku * 1.2f, "darkhit");
            new jisatukun2(s.Tjizoku * 1.2f).add(bullet);



            bullet.c.addmotion(new Kscalechangeman(10, "", s.Tsize * 2, s.Tsize * 2, 0, true, true));
            bullet.add(EM);

            float speed = 8;
            double kaku = k;

            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                bullet.c.addmotion(new idouman(s.Tjizoku * 1.2f, 0, 0, 33));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                bullet.c.addmotion(new idouman(s.Tjizoku * 1.2f, 0, 0, -33));
            }
            bullet.bif.kasoku(speed * (float)Math.Cos(kaku), speed * (float)Math.Sin(kaku));
            EEV.Sentitymaked(this, bullet);
        }
    }

    class firewand : Wepon
    {
        public firewand(Weponstatus s) : base(s, character.onepicturechara("weps\\firewand", 16, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.wind, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            go();
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(i, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.2f));
        }
        protected void go(inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);


            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\sunball", 12, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            hyoji.playoto("explosion2");

            var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "nothing", 0.7f, 0.5f, 0.1f, -1);
            d.hitted += (a, b) =>
            {

                if (EM.moves.Contains(b.tag))
                {

                    double kkaku = bullet.ab.getatari("core").nasukaku(b.tag.Acore);
                    float sp = 0;
                    if (bullet.s.mhel > 0)
                    {
                        sp = 50 * -b.s.hel / bullet.s.mhel;
                    }
                    b.tag.bif.kasoku(sp * (float)Math.Cos(kkaku), sp * (float)Math.Sin(kkaku), 100);
                }
            };
            new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);


            var m = new motion();
            m.addmoves(new Kscalechangeman(s.Tjizoku * sss.jizoku, "",
                s.Tsize * p.s.jizoku * sss.jizoku * sss.size
                , s.Tsize * p.s.jizoku * sss.jizoku * sss.size, 0, true, true));
            bullet.add(EM);

            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {
                    float hitritu = fileman.whrandhani(1000) / 100f;
                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hitritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hitritu);
                    bullet.c.settxy(a.c.gettx() + a.bif.vx * hitritu, a.c.getty() + a.bif.vy * hitritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                bullet.c.settxy(i.x, i.y);
            }

            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);
            EEV.Sentitymaked(this, bullet);
        }



    }
    class icewand : Wepon
    {
        public icewand(Weponstatus s) : base(s, character.onepicturechara("weps\\icewand", 16, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.ice, zokusei.earth });
        }
        protected override void attack()
        {
            base.attack();
            float hiritu = fileman.whrandhani(1000) / 100f;
            go(-1, hiritu, null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.ice }));
            go(0, hiritu, null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.earth }));
            go(1, hiritu, null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.ice }));
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(-2.5f, 0, i, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.ice }));
            go(-1.5f, 0, i, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.ice }));
            go(-0.5f, 0, i, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.earth }));
            go(0.5f, 0, i, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.earth }));
            go(1.5f, 0, i, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.ice }));
            go(2.5f, 0, i, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, new List<zokusei> { zokusei.ice }));
        }
        protected void go(float cou, float hiritu, inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, new List<zokusei> { zokusei.ice });


            string tex = "effects\\icecle";
            if (sss.zokuseion(zokusei.earth)) tex = "effects\\togerock";

            var bullet = new Sentity(new status(s.Tdam * sss.dam, sss.Z), character.onepicturechara(tex, 12, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Triangle(0, 0) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            danganka d;
            if (sss.zokuseion(zokusei.earth))
            {
                d = new danganka(bullet, s.Tjizoku * sss.jizoku + 20, "icehit", 1, 1, 1, -1);
            }
            else
            {
                d = new danganka(bullet, s.Tjizoku * sss.jizoku + 20, "earthhit", 1f, 1f, 1f, -1);
            }

            new jisatukun2(s.Tjizoku * sss.jizoku + 20).add(bullet);

            {
                var k = new Waza(20);
                k.removed += (a, b) => { bullet.bif.ay = 2 * sss.speed; };
                k.add(bullet);

                var mm = new motion(new radtoman(1, "", 90, 360));
                mm.addmoves(new scalechangeman(10, -1, "", 1, bullet.c.w / bullet.c.h / 2));
                mm.start(bullet.c);
                mm.frame(bullet.c, 100);
                bullet.c.setkijyuns();
            }
            var m = new motion();
            m.addmoves(new Kscalechangeman(20, "",
                s.Tsize * sss.size
                , s.Tsize * sss.size, 0, true, true));



            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {

                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hiritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hiritu);
                    bullet.c.settxy(a.c.gettx() + a.bif.vx * hiritu, a.c.getty() + a.bif.vy * hiritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                bullet.c.settxy(i.x, i.y);
            }

            if (c.mirror)
            {
                if (0 <= cou && cou < 1)
                {
                    this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                }
            }
            else
            {
                if (0 <= cou && cou < 1)
                {
                    this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                }
            }

            bullet.c.addmotion(m);
            {
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, -10000, "", -1);
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, 40000, "", -1);
                bullet.c.settxy(bullet.c.gettx() + bullet.c.h * cou * s.Tsize * sss.size * 1.5f, bullet.c.getty() - bullet.c.w * s.Tsize * sss.size * 3);
            }

            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }



    }
    class windwand : Wepon
    {
        public windwand(Weponstatus s) : base(s, character.onepicturechara("weps\\windwand", 16, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.wind, zokusei.ice, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            go(null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(i, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.5f, null));
        }
        protected void go(inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, new List<zokusei> { zokusei.ice });


            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\icetatumaki", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Triangle(0, 0) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            hyoji.playoto("windfooo");
            danganka d = new danganka(bullet, s.Tjizoku * sss.jizoku, "windfooo", 0.5f, 0.5f, 0.1f, -1);
            d.hitted += (a, b) =>
            {

                if (EM.moves.Contains(b.tag))
                {

                    double kkaku = -Math.PI / 2;
                    float spp = 0;
                    if (bullet.s.mhel > 0)
                    {
                        spp = 50;
                    }
                    b.tag.bif.kasoku(spp * (float)Math.Cos(kkaku), spp * (float)Math.Sin(kkaku), 100);
                }
            };
            new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);

            {


                var mm = new motion(new radtoman(1, "", 90, 360));
                mm.start(bullet.c);
                mm.frame(bullet.c, 100);
                bullet.c.setkijyuns();
            }
            var m = new motion();

            m.addmoves(new zkaitenman(s.Tjizoku * sss.jizoku, "", 0, 30 * s.Tjizoku * sss.jizoku, -1, true));


            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {
                    float hiritu = fileman.whrandhani(1000) / 100f;
                    hiritu = 0;
                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hiritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hiritu);
                    // bullet.c.settxy(a.c.gettx() + a.bif.vx * hiritu, a.c.getty() + a.bif.vy * hiritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                // bullet.c.settxy(i.x, i.y);
            }
            float sp = 10 * sss.speed;
            bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));
            if (c.mirror)
            {

                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {

                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

            bullet.c.addmotion(m);


            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }

    }

    class earthwand : Wepon
    {
        public earthwand(Weponstatus s) : base(s, character.onepicturechara("weps\\earthwand", 16, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.earth, zokusei.dark });
        }
        protected override void attack()
        {
            base.attack();
            go(null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(i, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f, null));
        }
        protected void go(inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, new List<zokusei> { zokusei.ice });


            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.earth }), character.onepicturechara("effects\\rockblock", 12, 111, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "" }, new List<Shape> { new Rectangle(0, 0) })
                , new buturiinfo(10000, 1, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            var bullet2 = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.dark }), character.onepicturechara("effects\\darkbit", 12, 100, false, 0.5f, 0.5f, opa: 1f)
             , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
             , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            hyoji.playoto("earthgogogo");
            danganka d = new danganka(bullet, 15, "nothing", 0.5f, 0.5f, 0f, -1);
            danganka dd = new danganka(bullet, 15, "darkhit", 0.5f, 0.5f, 0.1f, -1);

            new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
            new jisatukun2(15).add(bullet2);

            bullet2.c.addmotion(new scalechangeman(15, -1, "", s.Tsize * sss.size * 2, 2 * s.Tsize * sss.size));
            var m = new motion();
            m.addmoves(new scalechangeman(15, -1, "", s.Tsize * sss.size, s.Tsize * sss.size));



            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {
                    float hiritu = fileman.whrandhani(1000) / 100f;
                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hiritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hiritu);
                    bullet.c.settxy(a.c.gettx() + a.bif.vx * hiritu, a.c.getty() + a.bif.vy * hiritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                bullet.c.settxy(i.x, i.y);
            }
            bullet2.c.settxy(bullet.c.gettx(), bullet.c.getty());

            if (c.mirror)
            {

                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {

                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

            bullet.c.addmotion(m);


            bullet.add(EM);
            bullet2.add(EM);
            EEV.Sentitymaked(this, bullet);
            EEV.Sentitymaked(this, bullet2);
        }

    }
    class thunderwand : Wepon
    {
        public thunderwand(Weponstatus s) : base(s, character.onepicturechara("weps\\thunderwand", 16, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.thunder, zokusei.light, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            go(null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(i, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f, null));
        }
        protected void go(inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, new List<zokusei> { zokusei.ice });


            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\lightning", 12, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { }, new List<Shape> { })
                , new buturiinfo(1, 1, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            var sc = new scalechangeman(1, -1, "", 1, 1.5f);
            sc.start(bullet.c);
            sc.frame(bullet.c, 10);

            bullet.c.core.p.textures.Add("red", "redbit");

            bullet.c.core.p.texname = "red";
            bullet.c.core.p.OPA = 0.4f;


            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));
            var w = new Waza(20);
            w.removed += (a, b) =>
             {
                 hyoji.playoto("kaminari");
                 bullet.setNewAtariBinding(new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) }));
                 danganka d = new danganka(bullet, s.Tjizoku * sss.jizoku, "nothing", 0.8f, 0.6f, 0f, -1);

                 new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
                 bullet.c.core.p.texname = "def";
             };
            w.add(bullet);
            var m = new motion();




            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {
                    float hiritu = fileman.whrandhani(1000) / 100f;
                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hiritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hiritu);
                    bullet.c.settxy(a.c.gettx() + a.bif.vx * hiritu, a.c.getty() + a.bif.vy * hiritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                bullet.c.settxy(i.x, i.y);
            }

            if (c.mirror)
            {

                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {

                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

            bullet.c.addmotion(m);

            {
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, -10000, "", -1);
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, 40000, "", -1);

                float x = bullet.c.getcx(bullet.c.tx, bullet.c.h);
                float y = bullet.c.getcy(bullet.c.tx, bullet.c.h);
                bullet.c.scalechange(sss.size * s.Tsize, false);
                bullet.c.setcxy(x, y, bullet.c.tx, bullet.c.h);

            }

            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }

    }
    class lightwand : Wepon
    {
        public lightwand(Weponstatus s) : base(s, character.onepicturechara("weps\\lightwand", 16, 1, false, 0.5f, 0.1f)
                  , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.light, zokusei.fire, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            go(null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(i, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f, null));
        }
        protected void go(inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, new List<zokusei> { zokusei.ice });


            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\lightpillar", 12, 100, false, 0.5f, 0.05f, opa: 1f)
                , new ABrecipie(new List<string> { }, new List<Shape> { })
                , new buturiinfo(1, 1, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));
            {
                var sc = new scalechangeman(1, -1, "", sss.size * s.Tsize, 20);
                sc.start(bullet.c);
                sc.frame(bullet.c, 10);
            }
            bullet.c.core.p.textures.Add("red", "redbit");

            bullet.c.core.p.texname = "red";
            bullet.c.core.p.OPA = 0.4f;


            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));
            var w = new Waza(25);
            w.removed += (a, b) =>
            {
                hyoji.playoto("lightkiin");
                bullet.setNewAtariBinding(new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) }));

                danganka d = new danganka(bullet, s.Tjizoku * sss.jizoku, "nothing", 0.8f, 0.6f, 0f, -1);

                new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
                bullet.c.core.p.texname = "def";
            };
            w.add(bullet);
            var m = new motion();




            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {
                    float hiritu = fileman.whrandhani(1000) / 100f;
                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hiritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hiritu);
                    //    bullet.c.settxy(a.c.gettx() + a.bif.vx * hiritu, a.c.getty() + a.bif.vy * hiritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                // bullet.c.settxy(i.x, i.y);
            }
            bullet.c.settxy(p.c.gettx(), p.c.getty());
            {
                var sc = new radtoman(1, "", kaku / Math.PI * 180 - 90, 360);
                sc.start(bullet.c);
                sc.frame(bullet.c, 10);
            }

            if (c.mirror)
            {

                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {

                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

            bullet.c.addmotion(m);

            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }
    }
    class darkwand : Wepon
    {
        public darkwand(Weponstatus s) : base(s, character.onepicturechara("weps\\darkwand", 16, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.thunder, zokusei.dark, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            double kaku = fileman.whrandhani(360) * Math.PI / 180;
            float hiritu = fileman.whrandhani(1000) / 100f;
            go(kaku, hiritu, null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
            go(kaku + Math.PI / 2, hiritu, null, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            double kaku = fileman.whrandhani(360) * Math.PI / 180;
            go(kaku, 0, i, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f, null));
            go(kaku + Math.PI / 2, 0, i, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f, null));
        }
        protected void go(double jkaku, float hiritu, inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, new List<zokusei> { zokusei.ice });


            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\darkthunderbit", 12 * sss.size * s.Tsize, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { }, new List<Shape> { })
                , new buturiinfo(1, 1, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));
            {
                var sc = new scalechangeman(1, -1, "", 1, 6);
                sc.start(bullet.c);
                sc.frame(bullet.c, 10);
            }
            bullet.c.core.p.textures.Add("red", "redbit");

            bullet.c.core.p.texname = "red";
            bullet.c.core.p.OPA = 0.4f;


            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));
            var w = new Waza(25);
            w.removed += (a, b) =>
            {
                hyoji.playoto("darkhassya");

                bullet.setNewAtariBinding(new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) }));
                danganka d = new danganka(bullet, s.Tjizoku * sss.jizoku, "nothing", 0.8f, 0.6f, 0f, -1);

                new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
                bullet.c.core.p.texname = "def";
            };
            w.add(bullet);

            {
                var sc = new radtoman(1, "", jkaku / Math.PI * 180, 360);
                sc.start(bullet.c);
                sc.frame(bullet.c, 10);
            }
            var m = new motion();




            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {

                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hiritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hiritu);
                    bullet.c.settxy(a.c.gettx() + a.bif.vx * hiritu, a.c.getty() + a.bif.vy * hiritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                bullet.c.settxy(i.x, i.y);
            }

            if (c.mirror)
            {

                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {

                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

            bullet.c.addmotion(m);


            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }

    }
    class timwand : Wepon
    {
        public timwand(Weponstatus s) : base(s, character.onepicturechara("weps\\timwand", 16, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
        }
        protected override void attack()
        {
            base.attack();
            float x = c.gettx(), y = c.getty();
            foreach (var a in p.tag)
            {
                float hiritu = fileman.whrandhani(1000) / 100f;
                hiritu = 0;
                y = a.c.getty() + a.bif.vy * hiritu;
                x = a.c.gettx() + a.bif.vx * hiritu;
                // bullet.c.settxy(a.c.gettx() + a.bif.vx * hiritu, a.c.getty() + a.bif.vy * hiritu);
                break;
            }
            go(0, 0, x, y, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
            go(2, 4, x, y, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
            go(-2, 8, x, y, new PlayerStatus(0, 1, 1, 0, 0, 1, 1, null));
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(0, 0, i.x, i.y, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.5f, null));
            go(4, 4, i.x, i.y, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.5f, null));
            go(-4, 8, i.x, i.y, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.5f, null));
        }
        protected void go(double henk, float mati, float ix, float iy, PlayerStatus sss = null)
        {

            henk = henk / 180 * Math.PI;
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, new List<zokusei> { zokusei.ice });

            Waza w = new Waza(mati);
            w.add(this);
            w.removed += (aaa, bbb) =>
            {
                var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\tim", 12, 100, false, 0.5f, 0.5f, opa: 1f)
                    , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                    , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));



                bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

                hyoji.playoto("firehassya");
                danganka d = new danganka(bullet, s.Tjizoku * sss.jizoku, "punch", 1f, 1f, 1f, -1);

                new jisatukun2(s.Tjizoku * sss.jizoku, 90).add(bullet);

                {


                    var mm = new motion(new radtoman(1, "", 90, 360));
                    mm.start(bullet.c);
                    mm.frame(bullet.c, 100);
                    bullet.c.setkijyuns();
                }
                var m = new motion();

                m.addmoves(new Kscalechangeman(10, "", s.Tsize * sss.size, s.Tsize * sss.size, 0));


                double kaku = 0;

                kaku = Math.Atan2(-bullet.c.getty() + iy, -bullet.c.gettx() + ix);
                // bullet.c.settxy(i.x, i.y);

                float sp = 15 * sss.speed;
                bullet.bif.kasoku(sp * (float)Math.Cos(kaku + henk), sp * (float)Math.Sin(kaku + henk));
                if (c.mirror)
                {

                    this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

                }
                else
                {

                    this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

                }

                bullet.c.addmotion(m);


                bullet.add(EM);
                EEV.Sentitymaked(this, bullet);
            };
        }

    }

    class firecane : Wepon
    {
        public firecane(Weponstatus s) : base(s, character.onepicturechara("weps\\firecane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            go();
        }
        protected override void skill(inputin i)
        {
            base.skill(i);
            go(i, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f));
        }
        protected void go(inputin i = null, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);


            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.fire, zokusei.energy }), character.onepicturechara("effects\\firepillar", 12, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { }, new List<Shape> { })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));
            {
                for (int ij = 1; ij <= 4; ij++)
                {
                    float w = bullet.c.w;
                    float h = bullet.c.h;
                    bullet.c.core.sts.Add(new setu(ij.ToString(), w / 2, h / 2, new picture(0, 0, 110
                        , w, h, w / 2, h / 2, 0, false, 1, "def", new Dictionary<string, string> { { "def", @"effects\firepillar" } }), new List<setu>()));

                    var mm = new motion();
                    mm.loop = true;

                    mm.addmoves(new zkaitenman((1 + ij * 0.5f) * 30, ij.ToString(), 0, 360, 1, false, true));

                    bullet.c.addmotion(mm);
                }

                bullet.c.setkijyuns();
            }
            bullet.c.core.p.textures["def"] = "redbit";
            foreach (var a in bullet.c.getallsetu()) a.p.OPA = 0;
            bullet.c.core.p.OPA = 0.4f;

            var ww = new Waza(20);
            ww.add(bullet);
            ww.removed += (aahas, auighiauhg) =>
            {
                bullet.c.core.p.textures["def"] = "nothing";
                bullet.setNewAtariBinding(new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) }));
                var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "nothing", 0.5f, 0.3f, 0.05f, 5);

                d.hitted += (a, b) =>
                {
                    var www = (Waza)a;
                    if (!www.atarisAru(bullet, 78125))
                    {
                        www.atarisAdd(bullet, 9999999, 78125);
                        hyoji.playoto("firekarakara", 1);
                    }

                };

                d.framed += (a, b) =>
                 {
                     var www = (Waza)a;
                     if (!www.atarisAru(bullet, 78124))
                     {
                         www.atarisAdd(bullet, 5, 78124);
                         hyoji.playoto("firefosa", 0.5f);
                     }
                 };

                new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
            };

            var m = new motion();

            bullet.add(EM);

            double kaku = 0;
            if (i == null)
            {
                foreach (var a in p.tag)
                {
                    float hitritu = fileman.whrandhani(1000) / 100f;
                    kaku = Math.Atan2(-bullet.c.getty() + a.c.getty() + a.bif.vy * hitritu, -bullet.c.gettx() + a.c.gettx() + a.bif.vx * hitritu);
                    bullet.c.settxy(a.c.gettx() + a.bif.vx * hitritu, a.c.getty() + a.bif.vy * hitritu);
                    break;
                }
            }
            else
            {
                kaku = Math.Atan2(-bullet.c.getty() + i.y, -bullet.c.gettx() + i.x);
                bullet.c.settxy(i.x, i.y);
            }

            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);

            {
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, -10000, "", -1);
                FP.zuresaseEntity(bullet, EM, new Rectangle(0, 0), 0, 40000, "", -1);

                float x = bullet.c.getcx(bullet.c.tx, bullet.c.h);
                float y = bullet.c.getcy(bullet.c.tx, bullet.c.h);
                bullet.c.scalechange(sss.size * s.Tsize, false);
                bullet.c.setcxy(x, y, bullet.c.tx, bullet.c.h);

            }

            EEV.Sentitymaked(this, bullet);
        }

    }
    class icecane : Wepon
    {
        public icecane(Weponstatus s) : base(s, character.onepicturechara("weps\\icecane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.ice, zokusei.ice, zokusei.ice, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];
            for (int i = 0; i < 5; i++)
            {
                float xx = x, yy = y;
                Waza w = new Waza((i) * 5);
                w.removed += (aa, bb) =>
                {

                    if (i != 0)
                    {
                        float kyo = 15 * s.Tsize * (fileman.whrandhani(90) + 10) / 100;
                        double kaku = fileman.r.NextDouble() * Math.PI * 2;
                        xx += kyo * (float)Math.Cos(kaku);
                        yy += kyo * (float)Math.Sin(kaku);
                    }
                    go(xx, yy, (7 - i) * 8);
                };
                w.add(this);
            }

        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;
            for (int i = 0; i < 5; i++)
            {
                float xx = x, yy = y;
                Waza w = new Waza((i) * 5);
                w.removed += (aa, bb) =>
                {

                    if (i != 0)
                    {
                        float kyo = 15 * s.Tsize * (fileman.whrandhani(90) + 10) / 100;
                        double kaku = fileman.r.NextDouble() * Math.PI * 2;
                        xx += kyo * (float)Math.Cos(kaku);
                        yy += kyo * (float)Math.Sin(kaku);
                    }
                    go(xx, yy, (7 - i) * 8, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f));
                };
                w.add(this);
            }
        }
        protected void go(float x, float y, float mati, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            bool mm = c.mirror;
            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.ice, zokusei.energy }), character.onepicturechara("effects\\icestar", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { }, new List<Shape> { })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            foreach (var a in bullet.c.getallsetu()) a.p.OPA = 0f;
            hyoji.playoto("iceshield");
            var ww = new Waza(mati);
            ww.add(bullet);
            ww.removed += (aahas, auighiauhg) =>
            {
                bullet.setNewAtariBinding(new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) }));
                var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "nothing", 0.5f, 0.5f, 0.1f, -1);

                if (mm)
                {
                    bullet.c.addmotion(new idouman(s.Tjizoku * sss.jizoku, 0, 0, 20));
                    bullet.c.addmotion(new scalechangeman(s.Tjizoku * sss.jizoku, -1, "", 0, 0));
                }
                else
                {
                    bullet.c.addmotion(new idouman(s.Tjizoku * sss.jizoku, 0, 0, -20));
                    bullet.c.addmotion(new scalechangeman(s.Tjizoku * sss.jizoku, -1, "", 0, 0));
                }

                hyoji.playoto("icebarin", 1);


                new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
            };

            var m = new motion();

            bullet.add(EM);

            double kaku = 0;

            {
                kaku = Math.Atan2(-bullet.c.getty() + y, -bullet.c.gettx() + x);
                bullet.c.settxy(x, y);
            }

            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                m.addmoves(new idouman(mati, 0, 0, 5));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                m.addmoves(new idouman(mati, 0, 0, -5));
            }
            m.addmoves(new Kopaman(mati, "", 1));
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
        }

    }

    class windcane : Wepon
    {
        public windcane(Weponstatus s) : base(s, character.onepicturechara("weps\\windcane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.wind, zokusei.wind, zokusei.wind, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];


            go(x, y, 0);
            go(x, y, 1);
            go(x, y, -1);

        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, 0, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.5f));
            go(x, y, 1, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.5f));
            go(x, y, -1, new PlayerStatus(0, 1, 2, 0, 0, 1.2f, 1.5f));
        }
        protected void go(float x, float y, float yin, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.wind, zokusei.energy }), character.onepicturechara("effects\\wind_cutter", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "zangeki", 0.8f, 0.7f, 0.1f, -1);
            d.otoadd("windhit", 1);


            hyoji.playoto("windfooo", 1);


            new jisatukun2(s.Tjizoku * sss.jizoku, 0).add(bullet);


            var m = new motion();

            bullet.add(EM);

            double kaku = 0;
            float sp = 23;
            {
                kaku = Math.Atan2(-bullet.c.getty() + y, -bullet.c.gettx() + x);
                //  bullet.c.settxy(x, y);
                bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));

                float kyo = (float)Math.Sqrt(Math.Pow(x - bullet.c.gettx(), 2) + Math.Pow(y - bullet.c.getty(), 2));
                var sp2 = sp * yin;
                bullet.bif.kasoku(bullet, sp2 * (float)Math.Cos(kaku + Math.PI / 2)
                         , sp2 * (float)Math.Sin(kaku + Math.PI / 2), -1, 1);
                var nokori = kyo / sp/2;
                if (nokori > 0)
                {

                    d.framed += (a, b) =>
                    {
                        bullet.bif.kasoku(bullet, -sp2 / nokori * (float)Math.Cos(kaku + Math.PI / 2)
                            , -sp2 / nokori * (float)Math.Sin(kaku + Math.PI / 2), -1, b.cl);



                    };
                }
            }



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
        }

    }

    class earthcane : Wepon
    {
        public earthcane(Weponstatus s) : base(s, character.onepicturechara("weps\\earthcane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.earth, zokusei.earth, zokusei.earth });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];

            go(x, y);

        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, true, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f));

        }
        protected void go(float x, float y, bool say = false, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\rockball", 12, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) })
                , new buturiinfo(1, 0.005f, 1, 0, 0, 0, 0, 0.4f, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "dekaasioto", 0.5f, 0.5f, 0.1f, -1);



            new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);

            bool mmm = c.mirror;
            var m = new motion();

            bullet.add(EM);

            double kaku = 0;
            float sp = 15;
            {
                kaku = Math.Atan2(-bullet.c.getty() + y, -bullet.c.gettx() + x);
                //  bullet.c.settxy(x, y);

                if (!say) kaku = FP.entitysimulate<Entity>(bullet, x, y, 10, s.Tjizoku, 1);
                bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));


                d.framed += (a, b) =>
                {
                    var waa = (Waza)a;
                    if (mmm)
                    {
                        bullet.c.addmotion(new idouman(b.cl, 0, 0, bullet.bif.speed));
                    }
                    else
                    {
                        bullet.c.addmotion(new idouman(b.cl, 0, 0, -bullet.bif.speed));

                    }

                    var lis = EM.overweights;
                    Waza.atypefilter(lis, bullet.bif);
                    if (waa.timer > 3)
                    {
                        foreach (var asd in bullet.zurentekiyou(lis, bullet.ab.getatari("core"), bullet.pab.getatari("core"), true))
                        {
                            if (!waa.atarisAru(asd, 21127491))
                            {
                                hyoji.playoto("dekaasioto", 0.5f);
                            }
                            waa.atarisAdd(asd, 3, 21127491);
                        }
                    }


                };

            }

            m.addmoves(new scalechangeman(s.Tjizoku * sss.size, -1, "", s.Tsize * sss.size * sss.jizoku
                , s.Tsize * sss.size * sss.jizoku));

            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
        }

    }

    class thundercane : Wepon
    {
        public thundercane(Weponstatus s) : base(s, character.onepicturechara("weps\\thundercane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.thunder, zokusei.thunder, zokusei.thunder });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];

            go(x, y);

        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f));

        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\thunderball", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0, 0, 0, 0, 0, 0, 0f, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "thundergeki", 0.5f, 0.2f, 0.1f, -1);



            new jisatukun2(s.Tjizoku * sss.jizoku, 0).add(bullet);

            bool mmm = c.mirror;
            var m = new motion();

            bullet.add(EM);

            double kaku = 0;
            float sp = 15;
            {
                kaku = Math.Atan2(-bullet.c.getty() + y, -bullet.c.gettx() + x);
                //  bullet.c.settxy(x, y);

                kaku = FP.entitysimulate<Entity>(bullet, x, y, 10, s.Tjizoku, 1);
                //  bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));
            }
            bullet.c.settxy(x, y);
            Entity tag = settag(bullet, d);
            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));
            d.hitted += (a, b) => { tag = null; };

            d.framed += (a, b) =>
            {
                //改善点 重いかも
                if (tag == null)
                {
                    tag = settag(bullet, d);
                }
                else
                {
                    var kkaku = bullet.c.nasukaku(tag.c);
                    bullet.c.idouxy(b.cl * sp * (float)Math.Cos(kkaku), b.cl * sp * (float)Math.Sin(kkaku));
                    if (!tag.onEM) tag = null;
                }
            };




            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
        }
        protected Sentity settag(Entity bullet, Waza w)
        {
            var lis = bullet.EM.getTypeEnts<Sentity>();
            Waza.atypefilter(lis, bullet.bif);
            w.atarisfilter(lis);
            if (lis.Count == 0) return null;

            Sentity res = lis.First();
            double sait = Math.Sqrt(Math.Pow(bullet.c.gettx() - res.c.gettx(), 2) + Math.Pow(bullet.c.getty() - res.c.getty(), 2));
            foreach (var a in lis)
            {
                var tt = Math.Sqrt(Math.Pow(bullet.c.gettx() - res.c.gettx(), 2) + Math.Pow(bullet.c.getty() - res.c.getty(), 2));
                if (tt < sait)
                {
                    sait = tt;
                    res = a;
                }
            }
            return res;
        }
    }


    class lightcane : Wepon
    {
        public lightcane(Weponstatus s) : base(s, character.onepicturechara("weps\\lightcane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.light, zokusei.light, zokusei.light });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];


            go(x, y);

        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(0, 1, 2, 0, 0, 1.0f, 1.5f));
        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("effects\\lightpillar", 12 * s.Tsize * sss.size
                , 100, true, 0.5f, 0.05f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Rectangle(0, 0) })
                , new buturiinfo(1, 1, 1, 0, 0, 0, 0, 0.0f, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            float mati = 15;
            var www = new Waza(mati);
            www.add(bullet);
            hyoji.playoto("lightkyururira");
            www.removed += (a, b) =>
            {
                var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "zangeki", 0.8f, 0.7f, 0.1f, -1);



                new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
            };
            var m = new motion();

            bullet.add(EM);

            double kaku = 0;
            {
                kaku = Math.Atan2(-bullet.c.getty() + y, -bullet.c.gettx() + x);
                //  bullet.c.settxy(x, y);


                //   bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));


                m.addmoves(new moveman(mati, true));
                {
                    var mmo = new scalechangeman(10, -1, "", 1, 1.5f);
                    mmo.start(bullet.c);
                    mmo.frame(bullet.c, 100);
                }
                if (!c.mirror)
                {
                    var mmo = new radtoman(10, "", kaku / Math.PI * 180 - 90, 360);
                    mmo.start(bullet.c);
                    mmo.frame(bullet.c, 100);
                    m.addmoves(new idouman(s.Tjizoku * sss.jizoku, 0, 0, 15));
                }
                else
                {
                    var mmo = new radtoman(10, "", kaku / Math.PI * 180 + 90, 360);
                    mmo.start(bullet.c);
                    mmo.frame(bullet.c, 100);
                    m.addmoves(new idouman(s.Tjizoku * sss.jizoku, 0, 0, -15));
                }
            }


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));

            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
        }

    }
    class darkcane : Wepon
    {
        public darkcane(Weponstatus s) : base(s, character.onepicturechara("weps\\darkcane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.dark, zokusei.dark, zokusei.dark, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];

            double kikaku = fileman.whrandhani(200) / 100 * Math.PI;
            for (int j = 0; j < 9; j++)
            {
                go(x, y, Math.PI * 2 / 9 * j + kikaku);
            }

        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            double kikaku = fileman.whrandhani(200) / 100 * Math.PI;
            for (int j = 0; j < 10; j++)
            {
                go(x, y, Math.PI * 2 / 10 * j + kikaku, new PlayerStatus(0, 1, 2, 0, 0, 1.5f, 1.5f));
            }
        }
        protected void go(float x, float y, double kakuu, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.dark, zokusei.energy }), character.onepicturechara("effects\\darkball", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 5) })
                , new buturiinfo(1, 0.07f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));


            var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "darkhit", 1, 1, 1, -1);


            new jisatukun2(s.Tjizoku * sss.jizoku, 0).add(bullet);


            var m = new motion();

          

            double kaku = 0;
            float sp = 24;
            {
                kaku = Math.Atan2(-bullet.c.getty() + y, -bullet.c.gettx() + x);
                //  bullet.c.settxy(x, y);


                bullet.bif.kasoku(sp * (float)Math.Cos(kakuu), sp * (float)Math.Sin(kakuu));
                bullet.c.settxy(x - 12 * sp * (float)Math.Cos(kakuu), y - 12 * sp * (float)Math.Sin(kakuu));

            }
            bullet.add(EM);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
                bullet.c.addmotion(new idouman(s.Tjizoku * sss.jizoku, 0, 0, 22));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));
                bullet.c.addmotion(new idouman(s.Tjizoku * sss.jizoku, 0, 0, -22));
            }
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
        }

    }

    class timcane : Wepon
    {
        public timcane(Weponstatus s) : base(s, character.onepicturechara("weps\\timcane", 20, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];

            double kikaku = fileman.whrandhani(200) / 100 * Math.PI;

            go(x, y, kikaku);


        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            double kikaku = fileman.whrandhani(200) / 100 * Math.PI;

            go(x, y, kikaku, null);
            go(x, y, kikaku + Math.PI, null);

        }
        protected void go(float x, float y, double kakuu, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = new Sentity(new status(s.Tdam * sss.dam, s.Z), character.onepicturechara("tim\\kobusi", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0.00f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(c.getcx(c.tx, c.h * 0.9f), c.getcy(c.tx, c.h * 0.9f));

            float sp = 24;

            Waza w = new Waza(40);
            w.add(bullet);
            w.removed += (aa, bb) =>
            {
                var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "punch", 0.8f, 1, 0.2f, -1);

                hyoji.playoto("firehassya");
                new jisatukun2(s.Tjizoku * sss.jizoku, -90).add(bullet);

                bullet.bif.kasoku(sp * (float)Math.Cos(bullet.c.RAD + Math.PI / 2), sp * (float)Math.Sin(bullet.c.RAD + Math.PI / 2));
            };






            var m = new motion();

            bullet.add(EM);

            double kaku = 0;



            {
                kaku = Math.Atan2(-bullet.c.getty() + y, -bullet.c.gettx() + x);



                bullet.c.settxy(x, y);



            }
            player tag = null;
            var lis = EM.getTypeEnts<player>();
            if (lis.Count > 0)
            {
                tag = lis.First();
                float saik = tag.c.kyori(x, y);
                foreach (var a in lis)
                {
                    float kk = a.c.kyori(x, y);
                    if (saik > kk)
                    {
                        saik = kk;
                        tag = a;
                    }
                }
            }
            Waza.atypefilter(lis, bif);
            if (tag != null)
            {
                w.framed += (a, b) =>
                {
                    bullet.c.idouxy((tag.c.gettx() - 7 * sp * (float)Math.Cos(kakuu) - bullet.c.gettx()) / 10,
                        (tag.c.getty() - 7 * sp * (float)Math.Sin(kakuu) - bullet.c.getty()) / 10);

                    var kanku = bullet.c.nasukaku(tag.c);
                    bullet.c.addmotion(new radtoman(0.1f, "", kanku / Math.PI * 180 - 90, 3600));
                };
                bullet.c.settxy(tag.c.gettx() - 7 * sp * (float)Math.Cos(kakuu), tag.c.getty() - 7 * sp * (float)Math.Sin(kakuu));

            }


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            m.addmoves(new radtoman(0.1f, "", kakuu / Math.PI * 180 - 90, 3600));
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
        }

    }
    class star : Wepon
    {
        public star(Weponstatus s) : base(s, character.onepicturechara("weps\\star", 24, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];

            go(x, y);


        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;


            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 1.3f, 1.3f));
        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire, zokusei.energy })
                , character.onepicturechara("effects\\sun", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0.00f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            var bullet2 = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.ice, zokusei.ice, zokusei.ice, zokusei.energy })
                , character.onepicturechara("effects\\icestar", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0.00f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));


            bool kaiten = fileman.percentin(50);
            double kaku = fileman.whrandhani(1999) / 1000 * Math.PI;
            float kyori = bullet.c.w * 2;


            float tx = x, ty = y;

            bullet.c.settxy(tx + kyori * (float)Math.Cos(kaku), ty + kyori * (float)Math.Cos(kaku));
            bullet2.c.settxy(tx + kyori * (float)Math.Cos(kaku - Math.PI), ty + kyori * (float)Math.Cos(kaku - Math.PI));

            float mati = 44;
            {
                var d = new danganka(bullet, mati, "firekarakara", 0.5f, 1, 0.0f, -1);

                new jisatukun2(mati).add(bullet);
                d.framed += (a, b) =>
                {

                    float kyo = kyori * d.nokori / d.end;
                    double k = kaku + 2 * Math.PI * (d.nokori / d.end);
                    if (kaiten) k = kaku - 2 * Math.PI * (d.nokori / d.end);
                    d.e.c.settxy(tx + kyo * (float)Math.Cos(k), ty + kyo * (float)Math.Sin(k));
                    var r = new radtoman(1, "", k / Math.PI * 180, 360);
                    r.start(d.e.c);
                    r.frame(d.e.c, 100);
                };
                d.removed += (a, b) =>
                {
                    if (bullet2.onEM && bullet.c.gettx() - bullet2.c.gettx() < bullet.c.w / 10 && bullet.c.getty() - bullet2.c.getty() < bullet.c.w / 10)
                    {
                        bullet2.remove();
                        bomber(tx, ty, sss, kaiten);
                    }
                };
            }
            {
                var d = new danganka(bullet2, mati, "icegangan", 0.5f, 1, 0.0f, -1);

                new jisatukun2(mati).add(bullet2);
                d.framed += (a, b) =>
                {

                    float kyo = kyori * d.nokori / d.end;
                    double k = kaku + 2 * Math.PI * (d.nokori / d.end) - Math.PI;
                    if (kaiten) k = kaku - 2 * Math.PI * (d.nokori / d.end) - Math.PI;
                    d.e.c.settxy(tx + kyo * (float)Math.Cos(k), ty + kyo * (float)Math.Sin(k));
                    var r = new radtoman(1, "", k / Math.PI * 180, 360);
                    r.start(d.e.c);
                    r.frame(d.e.c, 100);
                };
                d.removed += (a, b) =>
                {
                    if (bullet.onEM && bullet.c.gettx() - bullet2.c.gettx() < bullet.c.w / 10 && bullet.c.getty() - bullet2.c.getty() < bullet.c.w / 10)
                    {
                        bullet.remove();
                        bomber(tx, ty, sss, kaiten);
                    }
                };
            }



            var m = new motion();

            bullet.add(EM);
            bullet2.add(EM);



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

            hyoji.playoto("meteoarrow");

            EEV.Sentitymaked(this, bullet);

            EEV.Sentitymaked(this, bullet2);
        }
        protected void bomber(float x, float y, PlayerStatus sss, bool kaiten)
        {
            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire, zokusei.energy })
               , character.onepicturechara("effects\\star", 12, 100, false, 0.5f, 0.5f, opa: 1f)
               , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 5) })
               , new buturiinfo(1, 0.00f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            bullet.c.settxy(x, y);
            hyoji.playoto("icebarin");
            hyoji.playoto("firehassya");
            {
                var d = new danganka(bullet, s.Tjizoku * sss.jizoku, "firekarakara", 0.8f, 1, 0.1f, -1);
                d.otoadd("icegangan", 1);

                new jisatukun2(s.Tjizoku * sss.jizoku).add(bullet);
            }

            bullet.c.addmotion(new scalechangeman(s.Tjizoku * sss.jizoku * 0.95f, -1, "", 4 * s.Tsize * p.s.jizoku * sss.size * sss.jizoku, 4 * s.Tsize * p.s.jizoku * sss.size * sss.jizoku));
            if (kaiten) bullet.c.addmotion(new idouman(s.Tjizoku * sss.jizoku, 0, 0, 44));
            else bullet.c.addmotion(new idouman(s.Tjizoku * sss.jizoku, 0, 0, 44));
            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }
    }
    class atom : Wepon
    {
        public atom(Weponstatus s) : base(s, character.onepicturechara("weps\\atom", 24, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.wind,zokusei.wind,zokusei.wind, zokusei.earth,zokusei.earth,zokusei.earth,
               zokusei.thunder,zokusei.thunder,zokusei.thunder, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];


            go(x, y);


        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;



            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 2f, 1.5f));
        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            Entity tag = null;
            foreach (var a in p.tag)
            {
                tag = a;
                Math.Atan2(-x + a.c.getty(), -y + a.c.gettx());
                break;
            }
            if (tag == null) tag = this;

            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.earth, zokusei.earth, zokusei.earth, zokusei.energy })
                , character.onepicturechara("effects\\earthatom", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 5) })
                , new buturiinfo(1, 0.7f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            var bullets = new List<Sentity>();
            for (int i = 0; i < 3; i++)
            {
                bullets.Add(new Sentity(new status(s.Tdam / 3 * sss.dam, new List<zokusei> { zokusei.thunder, zokusei.energy })
                   , character.onepicturechara("effects\\thunderatom", 12 / 3 * s.Tsize * sss.size, 102, false, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 5) })
                   , new buturiinfo(1, 0.7f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));
            }
            var bullets2 = new List<Sentity>();
            for (int i = 0; i < 2; i++)
            {
                var z = new List<zokusei> { zokusei.wind, zokusei.energy };
                if (i == 0) z.Add(zokusei.wind);
                bullets.Add(new Sentity(new status(s.Tdam / 2 * sss.dam, z)
                   , character.onepicturechara("effects\\windatom", 12 / 2 * s.Tsize * sss.size, 101, false, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 5) })
                   , new buturiinfo(1, 0.7f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));
            }


            bullet.c.settxy(this.c.getcx(this.c.tx, this.c.h * 0.8f), this.c.getcy(this.c.tx, this.c.h * 0.8f));
            foreach (var a in bullets) a.c.settxy(bullet.c.gettx() + fileman.whrandhani(a.c.w), bullet.c.getty() + fileman.whrandhani(a.c.w));
            foreach (var a in bullets2) a.c.settxy(bullet.c.gettx() + fileman.whrandhani(a.c.w), bullet.c.getty() + fileman.whrandhani(a.c.w));

            double kaku = bullet.c.nasukaku(tag.c);

            hyoji.playoto("thundershield");
            float sp = 1f;
            {
                var d = new danganka(bullet, this.s.Tjizoku * sss.jizoku, "earthjisin", 0.9f, 0.8f, 0.0f, -1);

                new jisatukun2(this.s.Tjizoku * sss.jizoku, 0).add(bullet);
                d.framed += (a, b) =>
                {
                    double k = bullet.c.nasukaku(tag.c);
                    double ti = (k - bullet.bif.speedvec);
                    float bai = (float)Math.Abs(Math.Atan2(Math.Sin(ti), Math.Cos(ti)));
                    bullet.bif.ax += (1 + bai) * sp * (float)Math.Cos(k);
                    bullet.bif.ay += (1 + bai) * sp * (float)Math.Sin(k);
                    bullet.bif.teikou = (float)(bai) + 0.4f;

                    if (!d.atarisAru(bullet))
                    {
                        new effectchara(hyoji, 5, bullet.c).addmotion(new texpropman(5, "", 471, 0));
                        d.atarisAdd(bullet, 5 + fileman.whrandhani(10));
                    }
                };

            }
            foreach (var bullet2 in bullets)
            {
                var d = new danganka(bullet2, this.s.Tjizoku * sss.jizoku, "thundergeki", 0.5f, 0.5f, 0.2f, -1);

                new jisatukun2(this.s.Tjizoku * sss.jizoku, 0).add(bullet2);
                d.framed += (a, b) =>
                {
                    double k = bullet2.c.nasukaku(bullet.c);
                    double ti = (k - bullet2.bif.speedvec);
                    if (!bullet.onEM) ti = 0;
                    float bai = (float)Math.Abs(Math.Atan2(Math.Sin(ti), Math.Cos(ti)));

                    if (bullet2.c.kyori(bullet.c) > bullet.c.w * 2)
                    {
                        float spp = bullet2.bif.speed;
                        bullet2.bif.vx += spp * (float)Math.Cos(k);
                        bullet2.bif.vy += spp * (float)Math.Sin(k);
                    }
                    bullet2.bif.ax += (2 + bai * 3) * sp * (float)Math.Cos(k);
                    bullet2.bif.ay += (2 + bai * 3) * sp * (float)Math.Sin(k);
                    bullet2.bif.teikou = (float)(bai / 4);
                    if (!d.atarisAru(bullet2))
                    {
                        new effectchara(hyoji, 5, bullet2.c).addmotion(new texpropman(5, "", 471, 0));
                        d.atarisAdd(bullet2, 5 + fileman.whrandhani(10));
                    }
                };
            }
            foreach (var bullet2 in bullets2)
            {
                var d = new danganka(bullet2, this.s.Tjizoku * sss.jizoku, "windfooo", 0.5f, 0.5f, 0.2f, -1);

                new jisatukun2(this.s.Tjizoku * sss.jizoku, 0).add(bullet2);
                d.framed += (a, b) =>
                {
                    double k = bullet2.c.nasukaku(bullet.c);
                    double ti = (k - bullet2.bif.speedvec);
                    if (!bullet.onEM) ti = 0;
                    float bai = (float)Math.Abs(Math.Atan2(Math.Sin(ti), Math.Cos(ti)));
                    if (bullet2.c.kyori(bullet.c) > bullet.c.w * 2)
                    {
                        float spp = bullet2.bif.speed;
                        bullet2.bif.vx += spp * (float)Math.Cos(k);
                        bullet2.bif.vy += spp * (float)Math.Sin(k);
                    }
                    bullet2.bif.ax += (1.5f + bai * 2) * sp * (float)Math.Cos(k);
                    bullet2.bif.ay += (1.5f + bai * 2) * sp * (float)Math.Sin(k);
                    bullet2.bif.teikou = (float)(bai / 4);
                    if (!d.atarisAru(bullet2))
                    {
                        new effectchara(hyoji, 5, bullet2.c).addmotion(new texpropman(5, "", 471, 0));
                        d.atarisAdd(bullet2, 5 + fileman.whrandhani(10));
                    }
                };
            }



            var m = new motion();

            bullet.add(EM);
            foreach (var a in bullets) a.add(EM);
            foreach (var a in bullets2) a.add(EM);



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);



            EEV.Sentitymaked(this, bullet);
            foreach (var a in bullets) EEV.Sentitymaked(this, a);
            foreach (var a in bullets2) EEV.Sentitymaked(this, a);
        }
    }
    class origin : Wepon
    {
        public origin(Weponstatus s) : base(s, character.onepicturechara("weps\\origin", 24, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.light, zokusei.light, zokusei.light,
                zokusei.dark, zokusei.dark, zokusei.dark, zokusei.energy });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];



            go(x, y);


        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;



            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 1, 1.5f));
        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            Entity tag = null;
            foreach (var a in p.tag)
            {
                tag = a;
                Math.Atan2(-x + a.c.getty(), -y + a.c.gettx());
                break;
            }
            if (tag == null) tag = this;

            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.dark, zokusei.dark, zokusei.dark, zokusei.energy })
                , character.onepicturechara("effects\\darkorigin", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, opa: 1f)
                , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
                , new buturiinfo(1, 0.00f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));






            bullet.c.settxy(this.c.getcx(this.c.tx, this.c.h * 0.8f), this.c.getcy(this.c.tx, this.c.h * 0.8f));
            double kaku = bullet.c.nasukaku(x, y);

            hyoji.playoto("darkgene");
            float sp = 14f;
            {
                bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));

                var d = new danganka(bullet, this.s.Tjizoku * sss.jizoku, "darkhit", 1f, 1, 0.0f, -1);
                d.framed += (a, b) =>
                 {
                     if (bullet.c.kyori(x + Math.Abs(bullet.c.w) * (float)Math.Cos(bullet.bif.speedvec), y + Math.Abs(bullet.c.w) * (float)Math.Sin(bullet.bif.speedvec)) < Math.Abs(bullet.c.w))
                     {
                         bullet.bif.vx = 0;
                         bullet.bif.vy = 0;
                     }
                 };
                d.removed += (a, b) =>
                {
                    bomber(bullet.c.gettx(), bullet.c.getty(), sss);
                };
                new jisatukun2(this.s.Tjizoku * sss.jizoku).add(bullet);
                bullet.c.addmotion(new idouman(this.s.Tjizoku * sss.jizoku, 0, 0, 30 + fileman.whrandhani(360)));

            }




            var m = new motion();

            bullet.add(EM);



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }
            bullet.c.addmotion(m);


            EEV.Sentitymaked(this, bullet);
        }

        protected void bomber(float x, float y, PlayerStatus sss)
        {
            hyoji.playoto("lightpaaa");
            bool kaiten = fileman.percentin(50);
            var bullet = new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.light, zokusei.light, zokusei.energy })
               , character.onepicturechara("effects\\lightorigin", 12, 100, false, 0.5f, 0.5f, opa: 1f)
               , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 10) })
               , new buturiinfo(1, 0.00f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));
            float mati = this.s.Tjizoku / 2;
            bullet.c.settxy(x, y);
            {
                var d = new danganka(bullet, mati * sss.jizoku, "lighthit", 0.8f, 0.5f, 0.0f, 10);


                new jisatukun2(mati * sss.jizoku).add(bullet);
            }

            bullet.c.addmotion(new scalechangeman(mati * sss.jizoku * 0.95f, -1, "", 3 * s.Tsize * p.s.jizoku * sss.size * sss.jizoku, 3 * s.Tsize * p.s.jizoku * sss.size * sss.jizoku));
            if (kaiten) bullet.c.addmotion(new idouman(mati * sss.jizoku, 0, 0, 32));
            else bullet.c.addmotion(new idouman(mati * sss.jizoku, 0, 0, 32));
            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }
    }
    class hugemagic : Wepon
    {
        public hugemagic(Weponstatus s) : base(s, character.onepicturechara("weps\\hugemagic", 24, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.ice, zokusei.wind, zokusei.earth, zokusei.thunder, zokusei.light, zokusei.dark });
        }
        protected override void attack()
        {
            base.attack();
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];



            go(x, y);


        }
        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;



            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 1, 1.8f));
        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);




            var bullets = new List<Sentity>();
            foreach (var a in this.s.Z)
            {
                bullets.Add(new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { a })
                   , character.onepicturechara("karuma\\" + a.ToString() + "hand", 12, 102, true, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Triangle(0, 0, hou: 2) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));
            }
            bullets.Sort((a, b) => (int)fileman.whrandhani(10) - 5);
            bullets.Sort((a, b) => (int)fileman.whrandhani(10) - 5);
            bullets.Sort((a, b) => (int)fileman.whrandhani(10) - 5);
            bullets.Sort((a, b) => (int)fileman.whrandhani(10) - 5);

            {
                foreach (var a in bullets) a.c.settxy(this.c.gettx() + fileman.whrandhani(a.c.w + a.c.h), this.c.getty() + fileman.whrandhani(a.c.w + a.c.h));
            }
            double kaku = this.c.nasukaku(x, y);

            float sp = 25f;
            float mati = 4;

            for (int j = 0; j < bullets.Count; j++)
            {
                var tyon = new Waza(j * 2);
                tyon.add(this);

                var bullet2 = bullets[j];
                tyon.removed += (ahj, bhj) =>
                 {
                     if (tyon.nokori <= 0)
                     {
                         var aas = bullet2.s.Z.First();
                         var d = new danganka(bullet2, this.s.Tjizoku * sss.jizoku, aas.ToString() + "hit", 0.8f, 0.8f, 0.15f, -1);
                         hyoji.playoto("shield");

                         new jisatukun2(mati + this.s.Tjizoku * sss.jizoku, -90).add(bullet2);


                         {
                             bullet2.c.settxy(this.c.gettx() + fileman.whrandhani((bullet2.c.w + bullet2.c.h) * 2)
                                 , this.c.getty() + fileman.whrandhani((bullet2.c.w + bullet2.c.h) * 2));
                         }

                         double k = bullet2.c.nasukaku(x, y);
                         bullet2.c.addmotion(new scalechangeman(mati, -1, "", s.Tsize * sss.size, s.Tsize * sss.size));
                         bullet2.add(EM);
                         var w = new Waza(mati);
                         w.add(bullet2);
                         bullet2.bif.kasoku(0.00001f * (float)Math.Cos(k), 0.00001f * (float)Math.Sin(k));
                         w.removed += (aaj, aakhj) => { bullet2.bif.kasoku(sp * (float)Math.Cos(k), sp * (float)Math.Sin(k)); };
                         EEV.Sentitymaked(this, bullet2);
                     }
                 };
            }








            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }



        }
    }


    class firefist : Wepon
    {
        public firefist(Weponstatus s) : base(s, character.onepicturechara("weps\\firefist", 26, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire });
        }
        int mode = 0;
        protected override void attack()
        {
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire });
            base.attack();
            s.setzokusei(new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire, zokusei.fire });
            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];


            switch (mode)
            {
                case 0:
                    go(x, y);
                    {
                        var w = new Waza(10);
                        w.removed += (a, b) => go1(x, y);
                        w.add(this);
                    }
                    mode = 1;
                    break;
                case 1:
                    go1(x, y);
                    {
                        var w = new Waza(10);
                        w.removed += (a, b) => go2(x, y);
                        w.add(this);
                    }
                    mode = 2;
                    break;
                case 2:
                    go2(x, y);
                    {
                        var w = new Waza(10);
                        w.removed += (a, b) => go(x, y);
                        w.add(this);
                    }
                    mode = 0;
                    break;
            }


        }

        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(1, 1, 2.666f, 1, 1, 1, 1.5f));
            {
                var w = new Waza(5);
                w.removed += (a, b) => go1(x, y, new PlayerStatus(1, 1, 2.666f, 1, 1, 1, 1.5f));
                w.add(this);
            }
            {
                var w = new Waza(10);
                w.removed += (a, b) => go2(x, y, new PlayerStatus(1, 1, 2.666f, 1, 1, 1, 1.5f));
                w.add(this);
            }
        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire })
                   , character.onepicturechara("effects\\firepunch2", 12, 102, true, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));

            {
                bullet.c.settxy(this.c.gettx(), this.c.getty());
            }
            double kaku = this.c.RAD + Math.PI + (fileman.whrandhani(100) - 50) / 1000;

            float mati = 15;


            {
                var d = new danganka(bullet, mati + this.s.Tjizoku * sss.jizoku, "firekarakara", 0.8f, 0.8f, 0f, -1);
                hyoji.playoto("firehassya");

                new jisatukun2(mati + this.s.Tjizoku * sss.jizoku).add(bullet);

                double k = Math.PI * fileman.whrandhani(199) / 100;
                bool migi = fileman.percentin(50);
                float kyo = 0;
                float sp = 3;
                double ksp = Math.PI / 30;
                float tx = bullet.c.gettx(), ty = bullet.c.getty();

                bullet.c.addmotion(new scalechangeman(mati, -1, "", s.Tsize * sss.size, s.Tsize * sss.size));
                bullet.add(EM);
                d.framed += (a, b) =>
                {
                    if (migi) k += ksp * b.cl; else k -= ksp * b.cl;
                    kyo += sp * b.cl;
                    bullet.c.settxy(tx + kyo * (float)Math.Cos(k), ty + kyo * (float)Math.Sin(k));
                    if (migi) new radtoman(10, "", k / Math.PI * 180, 360).startAndFrame(bullet.c, 100);
                    else new radtoman(10, "", 180 + k / Math.PI * 180, 360).startAndFrame(bullet.c, 100);
                };

            }
            EEV.Sentitymaked(this, bullet);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }

        protected void go1(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire })
                   , character.onepicturechara("effects\\firepunch2", 12, 102, true, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));

            {
                bullet.c.settxy(this.c.gettx(), this.c.getty());
            }
            double kaku = this.c.nasukaku(x, y);

            float mati = 15;
            float sp = 15;

            {
                var d = new danganka(bullet, mati + this.s.Tjizoku * sss.jizoku, "firekarakara", 0.8f, 0.8f, 0f, -1);
                hyoji.playoto("firehassya");


                new jisatukun2(mati + this.s.Tjizoku * sss.jizoku, -90).add(bullet);

                bullet.add(EM);
                bullet.c.addmotion(new scalechangeman(mati, -1, "", s.Tsize * sss.size, s.Tsize * sss.size));

                bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));

            }
            EEV.Sentitymaked(this, bullet);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }
        protected void go2(float x, float y, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.fire, zokusei.fire, zokusei.fire })
                   , character.onepicturechara("effects\\firepunch", 12, 102, true, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));

            {
                bullet.c.settxy(x, y);
            }
            double kaku = this.c.nasukaku(x, y);

            float mati = 25;

            {
                var d = new danganka(bullet, mati + this.s.Tjizoku * sss.jizoku, "firekarakara", 0.8f, 0.8f, 0f, -1);
                hyoji.playoto("firehassya");

                new jisatukun2(mati + this.s.Tjizoku * sss.jizoku).add(bullet);

                bullet.add(EM);
                bullet.c.addmotion(new scalechangeman(mati, -1, "", s.Tsize * sss.size, s.Tsize * sss.size));

                bullet.c.addmotion(new idouman(mati + this.s.Tjizoku * sss.jizoku, 0, 0, fileman.plusminus() * 15));
                EEV.Sentitymaked(this, bullet);
            }



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }
    }

    class iceedge : Wepon
    {
        public iceedge(Weponstatus s) : base(s, character.onepicturechara("weps\\iceedge", 26, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice });
        }
        protected override void attack()
        {
            s.setzokusei(new List<zokusei> { zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice });
            base.attack();
            s.setzokusei(new List<zokusei> { zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice, zokusei.ice });


            for (int i = 0; i < 5; i++)
            {
                var aan = getstdneraixy();
                float x = aan[0], y = aan[1];


                go(x, y, null, (1 + i) * 4, new PlayerStatus(1, 1, 1, 1, 1, 1, 1.5f));
            }


        }

        protected override void skill(inputin ii)
        {
            base.skill(ii);
            for (int i = 0; i < 20; i++)
            {
                var aan = getstdneraixy();
                float x = aan[0], y = aan[1];


                go(x, y, ii, (1 + i) * 2, new PlayerStatus(1, 1, 1, 1, 1, 1, 1.5f));
            }
        }
        protected void go(float x, float y, inputin i, float mati, PlayerStatus sss = null)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.ice })
                   , character.onepicturechara("effects\\iceslash", 12 * s.Tsize * sss.size, 102, false, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 5) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));

            double kaku = this.c.RAD + Math.PI * (fileman.whrandhani(199)) / 100;

            var waza = new Waza(mati);
            waza.add(this);
            waza.removed += (add, b) =>
              {
                  float si = Math.Abs(bullet.c.w) / 2 + Math.Abs(bullet.c.h) / 2;
                  if (!this.onEM) return;
                  if (i == null)
                  {
                      bullet.c.settxy(x + fileman.plusminus() * fileman.whrandhani(si), y + fileman.plusminus() * fileman.whrandhani(si));
                  }
                  else
                  {
                      bullet.c.settxy(i.x + fileman.plusminus() * fileman.whrandhani(si), i.y + fileman.plusminus() * fileman.whrandhani(si));
                  }
                  var d = new danganka(bullet, this.s.Tjizoku * sss.jizoku, "icehit", 0.8f, 0.8f, 0f, -1);
                  hyoji.playoto("zangeki");

                  new jisatukun2(this.s.Tjizoku * sss.jizoku).add(bullet);

                  new radtoman(10, "", fileman.whrandhani(359), 360).startAndFrame(bullet.c, 100);

                  EEV.Sentitymaked(this, bullet);
                  bullet.add(EM);

              };


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(5, "", -(kaku / Math.PI * 180 - 90), 105));
            }
            else
            {
                this.c.addmotion(new radtoman(5, "", kaku / Math.PI * 180 - 90, 105));

            }

        }

    }


    class windsound : Wepon
    {
        public windsound(Weponstatus s) : base(s, character.onepicturechara("weps\\windsound", 26, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.wind, zokusei.wind, zokusei.wind, zokusei.wind, zokusei.wind, zokusei.wind, zokusei.wind, zokusei.wind, zokusei.wind });
        }
        protected override void attack()
        {

            base.attack();

            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];



            go(x, y);

        }

        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 1.5f, 1.5f));

        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {
            float mati = 0;
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.wind, zokusei.wind, zokusei.wind, zokusei.wind })
                   , character.onepicturechara("effects\\onpu", 12, 102, true, 0.5f, 0.5f, opa: 1f)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 5) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));

            {
                bullet.c.settxy(this.c.gettx(), this.c.getty());
            }


            var m = new motion();
            m.loop = true;
            m.addmoves(new scalechangeman(1, 15, "", this.s.Tsize * sss.size, this.s.Tsize * sss.size));
            m.addmoves(new moveman(1, true));
            m.addmoves(new pplayotoman(hyoji, "teranokane", 0.75f));
            bullet.c.addmotion(m);


            double kaku = bullet.c.nasukaku(x, y);

            bullet.add(EM);
            bullet.setpab();
            float sp = 10;

            bullet.c.idouxy(sp * this.s.Tjizoku * sss.jizoku * (float)Math.Cos(kaku), sp * this.s.Tjizoku * sss.jizoku * (float)Math.Sin(kaku));

            bullet.setab();


            {

                var d = new danganka(bullet, mati + this.s.Tjizoku * sss.jizoku, "nothing", 0.6f, 0.5f, 0f, 15);

                d.framed += (z, b) =>
                {
                    var lis = EM.getTypeEnts<player>();
                    Waza.atypefilter(lis, bullet.bif, true);
                    ((Waza)z).atarisfilter(lis);
                    Waza.atafilter(lis,null,bullet,null);
                    foreach (var a in lis)
                    {
                        ((Waza)z).atarisAdd(a, 45);
                        var s = new status(bullet.s.hel * 0.5f);
                        bullet.EEV.Doinfluted(a, s);

                        bullet.s.influte(null, new status(-s.hel, s.Z), false);
                        hyoji.playoto("lightkyururira");
                    }
                };

                new jisatukun2(mati + this.s.Tjizoku * sss.jizoku).add(bullet);
                {
                    //   bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));
                    var lis = EM.overweights;
                    lis.AddRange(EM.getTypeEnts<Sentity>());
                    Waza.atypefilter(lis, bullet.bif);
                    //   Waza.atafilter(lis,null,bullet,null);
                    var ataling = new List<Entity>();
                    foreach (var a in lis)
                    {
                        var b = new Entity(a);
                        b.bif.wei = -1;

                        if (a.Acore == null && a.PAcore == null)
                        {
                            if (a.ab.getallatari().Count > 0 && a.pab.getallatari().Count > 0)
                            {
                                b.ab.coresugekae(a.ab.getallatari()[0].clone());
                                b.pab.coresugekae(a.pab.getallatari()[0].clone());
                            }
                        }
                        else
                        {
                            b.ab.coresugekae(a.Acore.clone());
                            b.pab.coresugekae(a.PAcore.clone());
                        }
                        ataling.Add(b);
                    }
                    {

                        {
                            var nc = new Circle(0, 0, pointkinji: 10);
                            nc.settxy(bullet.ab.getatari("core").gettx(), bullet.ab.getatari("core").getty());
                            //Console.WriteLine(ataling.Count+" asflk;a "+ bullet.ab.getallatari()[0].gettx()+" :: " + bullet.pab.getallatari()[0].gettx());
                            foreach (var a in bullet.zurentekiyou(ataling, bullet.ab.getatari("core"), bullet.pab.getatari("core")))
                            {
                                //    Console.WriteLine(a.bif.wei+" asdas "+a.c.gettx()+" ;;; "+a.c.w);
                            }
                            //  Console.WriteLine(ataling.Count + " asflk;a " + bullet.ab.getallatari()[0].gettx() + " :: " + bullet.pab.getallatari()[0].gettx());

                        }


                    }

                }
                bullet.setab(true);


            }
            EEV.Sentitymaked(this, bullet);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }

    }
    class eartharm : Wepon
    {
        public eartharm(Weponstatus s) : base(s, character.onepicturechara("weps\\eartharm", 26, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth });
        }
        protected override void attack()
        {

            base.attack();

            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];



            go(x, y);

        }

        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 1.5f, 1.5f));

        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {

            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            character cccc = character.onepicturechara("weps\\eartharm", 12, 100, false, 0.5f, 0.1f, opa: 1f);

            cccc.core.sts.Add(new setu("hand", cccc.core.p.tx, cccc.core.p.h * 0.9f, picture.onetexpic("weps\\earthhand", 12f / 62 * 40, 101, false, 0.5f, 0.1f, 1)));
            var ss = cccc.core.GetSetu("hand");
            ss.sts.Add(new setu("wep", ss.p.tx, ss.p.h * 0.9f, picture.onetexpic("weps\\earthwep", 12f / 62 * 60, 102, false, 0.5f, 0.1f, 1)));
            cccc.setkijyuns();
            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth, zokusei.earth })
                   , cccc
                   , new ABrecipie(new List<string> { "core", "hand", "wep" }, new List<Shape> { new Circle(0, 0, pointkinji: 5), new Circle(0, 0, pointkinji: 5), new Circle(0, 0, pointkinji: 5) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));

            {
                bullet.c.settxy(this.c.getcx(c.tx, c.h * 0.8f), this.c.getcy(c.tx, c.h * 0.8f));

            }
            bool R = x >= this.p.c.gettx();
            float mati = 45;
            float sp = 8;
            double kaku = c.nasukaku(x, y);
            float kk = (float)(kaku * 180 / Math.PI) - 90;
            var m = new motion();
            m.addmoves(new scalechangeman(mati, -1, "", s.Tsize * sss.size, s.Tsize * sss.size));
            m.addmoves(new radtoman(mati, "core", kk + 180, fileman.plusminus(R, false) * sp, false));
            m.addmoves(new radtoman(mati, "hand", kk + 180, fileman.plusminus(R, false) * sp, true));
            m.addmoves(new radtoman(mati, "wep", kk + 180, fileman.plusminus(R, false) * sp, true));
            m.addmoves(new moveman(mati, true));
            m.addmoves(new radtoman(mati, "core", kk, fileman.plusminus(R, false) * sp * 2, false));
            m.addmoves(new radtoman(mati, "hand", kk, fileman.plusminus(R, false) * sp * 2, true));
            m.addmoves(new radtoman(mati, "wep", kk, fileman.plusminus(R, false) * sp * 2, true));
            bullet.c.addmotion(m);

            hyoji.playoto("earthgogogo");
            hyoji.playoto("earthjisin");


            var w = new Waza(mati);
            w.framed += (aa, bb) =>
            {
                bullet.c.settxy(this.c.getcx(c.tx, c.h * 0.8f), this.c.getcy(c.tx, c.h * 0.8f));

            };
            w.add(bullet);
            w.removed += (a, b) =>
              {

                  var d = new danganka(bullet, mati, "dekaasioto", 0.7f, 0.7f, 0f, -1);



                  new jisatukun2(mati + this.s.Tjizoku * sss.jizoku).add(bullet);


                  bullet.setab(true);


              };
            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);


            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }

    }
    class thundersphere : Wepon
    {
        public thundersphere(Weponstatus s) : base(s, character.onepicturechara("weps\\thundersphere0", 26, 1, false, 0.5f, 0.5f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            c.core.p.textures.Add("0", "weps\\thundersphere0");
            c.core.p.textures.Add("1", "weps\\thundersphere1");
            c.core.p.textures.Add("2", "weps\\thundersphere2");
            c.core.p.textures.Add("3", "weps\\thundersphere3");
            c.core.p.textures.Add("4", "weps\\thundersphere4");
            c.core.p.textures.Add("5", "weps\\thundersphere5");
            var m = new motion();
            for (int i = 0; i < 6; i++)
            {
                m.addmoves(new texchangeman("core", i.ToString()));
                m.addmoves(new moveman(2, true));
            }
            m.loop = true;
            c.addmotion(m);
            s.setzokusei(new List<zokusei> { zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder });
        }
        protected override void attack()
        {

            base.attack();

            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];



            go(x, y);

        }

        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 1.5f, 1.5f));

        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {

            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);


            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder })
                   , new character(this.c, true, true)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));
            bullet.c.scalechange(s.Tsize * sss.size);
            {
                bullet.c.settxy(this.c.getcx(c.tx, c.h * 0.8f), this.c.getcy(c.tx, c.h * 0.8f));
            
                var m = new motion();
                for (int i = 0; i < 6; i++)
                {
                    m.addmoves(new texchangeman("core", i.ToString()));
                    m.addmoves(new moveman(2, true));
                }
                m.loop = true;
                bullet.c.addmotion(m);
            }
            float sp = 33;
            double kaku = c.nasukaku(x, y);

            hyoji.playoto("thundershield");

            {
                bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));
                var d = new danganka(bullet, this.s.Tjizoku * sss.jizoku, "thunderkarakara", 0.6f, 0.5f, 0f, 13);

                new jisatukun2(this.s.Tjizoku * sss.jizoku).add(bullet);


                bullet.setab(true);


            };
            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
            bullet.EEV.removed += (a, b) => { back(bullet, sss); };

            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }
        protected void back(Entity mo, PlayerStatus sss)
        {
            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);


            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder, zokusei.thunder })
                   , new character(this.c, true, true)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));
            bullet.c.scalechange(s.Tsize * sss.size);
            {
                bullet.c.settxy(mo.c.gettx(), mo.c.getty());

            }
            float sp = 33;
            double kaku = bullet.c.nasukaku(c.gettx(), c.getty());

            hyoji.playoto("thundershield");

            {
                bullet.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));
                var d = new danganka(bullet, this.s.Tjizoku * sss.jizoku, "thunderkarakara", 0.6f, 0.5f, 0f, 13);

                new jisatukun2(this.s.Tjizoku * sss.jizoku).add(bullet);


                bullet.setab(true);


            };
            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);
        }

    }

    class lightclaw : Wepon
    {
        float point = 0;
        public lightclaw(Weponstatus s) : base(s, character.onepicturechara("weps\\lightclaw", 26, 1, false, 0.5f, 0.1f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light });
        }
        protected override void attack()
        {
            s.setzokusei(new List<zokusei> { zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light });
            base.attack();
            s.setzokusei(new List<zokusei> { zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light });



            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];


            go(x, y, Math.PI / 4);

            go(x, y, -Math.PI / 4);

        }
        public override void frame(float cl)
        {
            base.frame(cl);
            if (point < 1) s.SkillTimer = 0;
        }
        protected override void onAdd()
        {
            base.onAdd();
            point = 0;
        }
        protected override void skill(inputin ii)
        {
            if (point >= 1)
            {
                base.skill(ii);
                float x = ii.x, y = ii.y;

                go(x, y, Math.PI / 4, false, new PlayerStatus(1, 1,  point, 1, 1, 1, 1 + (float)Math.Sqrt(point) / 2));

                go(x, y, -Math.PI / 4, false, new PlayerStatus(1, 1,  point, 1, 1, 1, 1 + (float)Math.Sqrt(point) / 2));

                point = 0;
            }
            else
            {
                fileman.playoto("TB\\buu");
            }
        }
        public override void UIn(int cou, inputin i, hyojiman h, float cl)
        {
            base.UIn(cou, i, h, cl);
            float si = h.ww / (ws.p.WS.Count + 1) / 2 / 4;

            if (goskill)
            {
                var eff = message.hutidorin(si / 15, i.x, i.y, si, 100, 50, 0, 0, point.ToString(), hyo: hyoji);
            }
            else
            {
                var eff = message.hutidorin(si / 15, h.camx + (cou + 1) * hyoji.ww / (ws.p.WS.Count + 1), h.camy + hyoji.wh * 0.8f, si, 100, 50, 0, 0, Math.Round(point, 1).ToString(), hyo: hyoji);
            }
        }
        protected void go(float x, float y, double rads, bool cha = true, PlayerStatus sss = null)
        {

            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);


            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.light, zokusei.light, zokusei.light, zokusei.light, zokusei.light })
                   , character.onepicturechara("weps\\sozai\\hikkaki", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, 1f, rads)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));
            bullet.c.scalechange(s.Tsize * sss.size);

            {
                bullet.c.settxy(x, y);
                var m = new motion();
                for (int i = 0; i < 6; i++)
                {
                    m.addmoves(new texchangeman("core", i.ToString()));
                    m.addmoves(new moveman(2, true));
                }
                m.loop = true;
                bullet.c.addmotion(m);
            }
            float mati = 8;
            double kaku = c.nasukaku(x, y);

            var w = new Waza(mati);
            w.add(this);
            w.removed += (a, b) =>
              {

                  hyoji.playoto("zangeki");
                  var d = new danganka(bullet, this.s.Tjizoku * sss.jizoku, "lighthit", 0.8f, 0.5f, 0f, -1);
                  if (cha)
                  {
                      bullet.EEV.damaged += (aa, bb) =>
                      {
                          point -= bb.s.hel / bullet.s.mhel * this.s.Tskill * 0.15f;

                      };
                  }
                
                  new jisatukun2(this.s.Tjizoku * sss.jizoku).add(bullet);


                  bullet.setab(true);
                  bullet.add(EM);
                  EEV.Sentitymaked(this, bullet);

              };



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }

    }
    class darksword : Wepon
    {
        public darksword(Weponstatus s) : base(s, character.onepicturechara("weps\\darksword", 26, 1, false, 0.5f, 0.5f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark });
            var m = new motion();

            m.addmoves(new idouman(10, 0, 0, 33));

            m.loop = true;
            c.addmotion(m);
        }
        protected override void attack()
        {
            s.setzokusei(new List<zokusei> { zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark });
            base.attack();
            s.setzokusei(new List<zokusei> { zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark, zokusei.dark });



            var aan = getstdneraixy();
            float x = aan[0], y = aan[1];


            go(x, y);


        }

        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(1, 1, 4, 1, 1, 1, 1.5f));

        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {

            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);


            var bullet = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.dark, zokusei.dark, zokusei.dark })
                   , character.onepicturechara("weps\\sozai\\sword", 12, 100, false, 0.5f, 0.1f, 1f,0)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));


            bullet.c.settxy(x, y);

            double kaku = c.nasukaku(x, y);

            float mati = 40;
            bullet.c.addmotion(new scalechangeman(mati/2, -1, "", s.Tsize * sss.size, s.Tsize * sss.size));
            new radtoman(mati, "",kaku/Math.PI*180, fileman.plusminus(x<=bullet.c.gettx())*12).startAndFrame(bullet.c,100);

          
            hyoji.playoto("darkgene");
            var w = new Waza(mati);
            w.add(this);
            w.removed += (a, b) =>
            {
                hyoji.playoto("darkhassya");
                bullet.c.addmotion(new idouman(s.Tjizoku*sss.jizoku, 0,0, -fileman.plusminus(x <= bullet.c.gettx()) * 28));
                var d = new danganka(bullet, this.s.Tjizoku * sss.jizoku, "zangeki", 0.9f, 0.8f, 0f, -1);
       
                bullet.EEV.damaged += (aa, bb) =>
                {
                    if (bb.sent != null)
                    {
                        kakera(-bb.s.hel, bullet);
                    }
                };
                bullet.EEV.dodamage += (aa, bb) =>
                {
                    if (bb.stag != null)
                    {
                        kakera(-bb.s.hel, bullet);
                    }
                };
                new jisatukun2(this.s.Tjizoku * sss.jizoku).add(bullet);


            
            };
            bullet.add(EM);
            EEV.Sentitymaked(this, bullet);



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }
        protected void kakera(float dam,Entity sey) 
        {
           // Console.WriteLine(dam + " a:pskf@oaskf@");
            
            {
                var bullet = (new Sentity(new status(dam, new List<zokusei> { zokusei.dark })
                        , character.onepicturechara("effects\\darkbit", 12, 100, false, 0.5f, 0.5f, 1f, 0)
                        , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                        , new buturiinfo(1, 0.0f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));

                float tx = fileman.whrandhani(sey.c.w);
                float ty = fileman.whrandhani(sey.c.h);
                bullet.c.settxy(sey.c.getcx(tx,ty), sey.c.getcy(tx, ty));

                float mati = 2;
                bullet.c.addmotion(new scalechangeman(mati, -1, "", s.Tsize , s.Tsize ));
                bullet.c.addmotion(new idouman(mati+s.Tjizoku,0,0,fileman.plusminus()*(30+fileman.whrandhani(30))));

                float sp = 16;
                double rad = Math.PI * fileman.whrandhani(2000) / 1000;

                bullet.bif.kasoku(sp*(float)Math.Cos(rad), sp * (float)Math.Sin(rad));

                var w = new Waza(mati);
                w.add(this);
                w.removed += (a, b) =>
                {
                    var d = new danganka(bullet, this.s.Tjizoku , "darkhit", 1, 1, 0f, -1);
                   
                    new jisatukun2(this.s.Tjizoku ).add(bullet);


                };
                bullet.add(EM);
                EEV.Sentitymaked(this, bullet);
            }
        }
    }
    class oursoul : Wepon
    {
        public oursoul(Weponstatus s) : base(s, character.onepicturechara("weps\\oursoul", 26, 1, false, 0.5f, 0.5f)
              , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0) }), new buturiinfo())
        {
            s.setzokusei(new List<zokusei> { zokusei.physical, zokusei.physical, zokusei.physical, zokusei.physical, zokusei.physical, zokusei.physical, zokusei.physical, zokusei.physical, zokusei.physical });
          
        }
        protected override void attack()
        {
            base.attack();
         
            float x = c.gettx()+fileman.plusminus()*fileman.whrandhani(12*s.Tsize*2), y = c.getty()+fileman.plusminus() * fileman.whrandhani(12 * s.Tsize * 2);


            go(x, y);


        }

        protected override void skill(inputin ii)
        {
            base.skill(ii);
            float x = ii.x, y = ii.y;

            go(x, y, new PlayerStatus(1, 1, 2, 1, 1, 1.5f, 1.5f));

        }
        protected void go(float x, float y, PlayerStatus sss = null)
        {

            if (sss == null) sss = new PlayerStatus(1, 1, 1, 1, 1, 1, 1, null);

            double kaku = c.nasukaku(x, y);

            var body = (new Sentity(new status(s.Tdam * sss.dam, new List<zokusei> { zokusei.physical, zokusei.physical, zokusei.physical })
                   , character.onepicturechara("weps\\sozai\\body", 12*s.Tsize*sss.size, 100, false, 0.5f, 0.5f, 1f, kaku)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.5f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag))));
            var rhand= new Sentity(body.s
                   , character.onepicturechara("weps\\sozai\\tRhand", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, 1f, 0)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.04f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));
            var lhand = new Sentity(body.s
                   , character.onepicturechara("weps\\sozai\\tLhand", 12 * s.Tsize * sss.size, 100, false, 0.5f, 0.5f, 1f, 0)
                   , new ABrecipie(new List<string> { "core" }, new List<Shape> { new Circle(0, 0, pointkinji: 8) })
                   , new buturiinfo(1, 0.04f, 0, 0, 0, 0, 0, 0, new List<string>(p.bif.atag)));

            new jisatukun2(s.Tjizoku * sss.jizoku, remveff: 45).add(body);
            new jisatukun2(s.Tjizoku * sss.jizoku,-90, remveff: 45).add(rhand);
            new jisatukun2(s.Tjizoku * sss.jizoku,-90, remveff: 45).add(lhand);

            body.c.settxy(x, y);
            rhand.c.settxy(x, y);
            lhand.c.settxy(x, y);

           

            hyoji.playoto("lightpaaa");

            float rtime = 40;
            float ltime = 20;
            float bodytime = 0;
            float acc = 1f *(1 + s.Tsize / 10);
            float pacc = 30  *(1 + s.Tsize / 10);
            rhand.EEV.framed += (a, b) =>
            {
                var kkk = rhand.c.nasukaku(body.c.getcx(body.c.w * 1.5f, body.c.ty), body.c.getcy(body.c.w * 1.5f, body.c.ty));
                rhand.bif.kasoku(rhand, acc * (float)Math.Cos(kkk), acc * (float)Math.Sin(kkk), -1, b.cl);
            };
            lhand.EEV.framed += (a, b) =>
            {
                var kkk = lhand.c.nasukaku(body.c.getcx(body.c.w * -0.5f, body.c.ty), body.c.getcy(body.c.w * -0.5f, body.c.ty));
                lhand.bif.kasoku(lhand, acc * (float)Math.Cos(kkk), acc * (float)Math.Sin(kkk), -1, b.cl);
            };
            body.EEV.framed += (a, b) =>
            {
              
                bodytime -= b.cl;
                rtime-=b.cl;
                ltime -= b.cl;
                if (rtime < 0) 
                {
                    rtime += 40;
                    punch(rhand, EM,pacc);
                }
                if (ltime < 0)
                {
                    ltime += 40;
                    punch(lhand, EM,pacc);

                }
                if (bodytime < 0) 
                {
                    bodytime += 20;
                    var t = getone(body, EM);
                    if (t != null)
                    {
                        var kkk = body.c.nasukaku(t.c);
                        body.c.addmotion(new radtoman(60, "", kkk / Math.PI * 180-90, 6));
                    }
                }
                {
                    var kkk = body.c.RAD + Math.PI / 2;
                    body.bif.kasoku(body, acc * (float)Math.Cos(kkk), acc * (float)Math.Sin(kkk), -1, b.cl);
                }

            };


            body.add(EM);
            rhand.add(EM);
            lhand.add(EM);

            EEV.Sentitymaked(this, body);
            EEV.Sentitymaked(this, rhand);
            EEV.Sentitymaked(this, lhand);



            if (c.mirror)
            {
                this.c.addmotion(new radtoman(15, "", -(kaku / Math.PI * 180 - 90), 15));
            }
            else
            {
                this.c.addmotion(new radtoman(15, "", kaku / Math.PI * 180 - 90, 15));

            }

        }
        protected Entity getone(Entity ss,EntityManager em) 
        {
            var tag = em.getTypeEnts(typeof(Sentity));
            Waza.atypefilter(tag, ss.bif);
            if (tag.Count > 0)
            {
                var tmp = tag[fileman.r.Next() % tag.Count];
                tag.Clear();
                tag.Add(tmp);
            }
            tag.AddRange(em.getTypeEnts(typeof(player)));
            Waza.atypefilter(tag, ss.bif);
            if (tag.Count > 0)
            {
                var tmp = tag[fileman.r.Next() % tag.Count];
                tag.Clear();
                tag.Add(tmp);
            }
            if (tag.Count > 0) 
            {
                return tag[0];
            }
            return null;
        }
        protected void punch(Sentity ss,EntityManager em,float sp) 
        {
            var t = getone(ss, em);
            if(t!=null)
            {
                double kaku = ss.c.nasukaku(t.c);
                ss.bif.kasoku(sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku));
                var d = new danganka(ss, 40, "punch", 0.3f, 0.3f, 0);
                hyoji.playoto("tane_hassya");
              //  Console.WriteLine(ss.s.mhel+"asgijaio ");
            }
        }
    }
}
