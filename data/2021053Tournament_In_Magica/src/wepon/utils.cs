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
    class jumper : Wepon
    {
        public jumper(Weponstatus s) : base(s, character.onepicturechara("weps\\jumper", 30, 2)
            , new ABrecipie(new List<string> { }, new List<Shape> { }), new buturiinfo())
        {

        }
        protected override void attack()
        {
            base.attack();

            float hi = (fileman.whrandhani(100) - 50) / 100;

            var m = new motion();
         //   m.addmoves(new Kscalechangeman(5, "", s.Tsize, s.Tsize, 0, true, false,true));
         //   m.addmoves(new Kscalechangeman(5, "", 1, 1));
            this.c.addmotion(m);

            new jump(s.dam * Math.Max(p.s.speed, 0) * (1 - Math.Abs(hi)), s.dam * Math.Max(p.s.speed, 0) * hi,"pyonko").add(p);
        }
        protected override void skill(inputin i)
        {
            base.skill(i);

            double k = this.p.Acore.nasukaku(i.x, i.y);

            var m = new motion();
            m.addmoves(new Kscalechangeman(5, "", s.Tsize, s.Tsize, 0, true, false, true));
            m.addmoves(new Kscalechangeman(5, "", 1, 1));
            this.c.addmotion(m);

            p.bif.kasoku(s.dam * Math.Max(p.s.speed, 0) * (float)Math.Cos(k), s.dam * Math.Max(p.s.speed,0) * (float)Math.Sin(k));
            hyoji.playoto("pyonko");
        }
    }
    class kasoker : Wepon
    {
        public kasoker(Weponstatus s) : base(s, character.onepicturechara("weps\\kasoker", 30, 2)
            , new ABrecipie(new List<string> { }, new List<Shape> { }), new buturiinfo())
        {

        }
        protected override void attack()
        {
            base.attack();

            double kaku = (-fileman.whrandhani(100)-40)/180*Math.PI;

            var m = new motion();
         //   m.addmoves(new Kscalechangeman(5, "", s.Tsize, s.Tsize, 0, true, false, true));
        //    m.addmoves(new Kscalechangeman(5, "", 1, 1));
            this.c.addmotion(m);

            hyoji.playoto("TB\\jett");
            float sp = s.dam * Math.Max(p.s.speed, 0);
            var kk = new kisekinokosi(s.jizoku,new List<string> {"effects\\physicbit" },6789,3,5,15,30,0,2,0.2f,1,-0.1f,30);
            kk.framed += (a, b) => 
            {
                b.ent.bif.kasoku(p, sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku), -1, b.cl);
            };
            kk.add(p);

        }
        protected override void skill(inputin i)
        {
            base.skill(i);

            double kaku = this.p.Acore.nasukaku(i.x, i.y);

            var m = new motion();
            m.addmoves(new Kscalechangeman(5, "", s.Tsize, s.Tsize, 0, true, false, true));
            m.addmoves(new Kscalechangeman(5, "", 1, 1));
            this.c.addmotion(m);

            hyoji.playoto("TB\\jett");
            float sp = s.dam * Math.Max(p.s.speed, 0);
            var kk = new kisekinokosi(s.jizoku, new List<string> { "effects\\physicbit" }, 6789, 3, 5, 15, 30, 0, 2, 0.2f, 1, 1, 30);
            kk.framed += (a, b) =>
            {
                b.ent.bif.kasoku(p, sp * (float)Math.Cos(kaku), sp * (float)Math.Sin(kaku), -1, b.cl);
            };
            kk.add(p);

        }
    }
    class warper : Wepon
    {
        public warper(Weponstatus s) : base(s, character.onepicturechara("weps\\warper", 30, 2)
            , new ABrecipie(new List<string> { }, new List<Shape> { }), new buturiinfo())
        {

        }
        protected override void attack()
        {
            base.attack();

            double kaku = (-fileman.whrandhani(100) - 40) / 180 * Math.PI;

            var m = new motion();
         //   m.addmoves(new Kscalechangeman(5, "", s.Tsize, s.Tsize, 0, true, false, true));
        //    m.addmoves(new Kscalechangeman(5, "", 1, 1));
            this.c.addmotion(m);

            hyoji.playoto("darkhassya");
            float kyo = s.dam * Math.Max(p.s.speed, 0)*(fileman.whrandhani(50)+50)/100;

            new effectchara(p.hyoji, 40, p.c).addmotion(new Kopaman(40, "", 0));

            p.c.idouxy(kyo * (float)Math.Cos(kaku), kyo * (float)Math.Sin(kaku));
          
            p.setab(false);
            
            p.zurentekiyou(p.EM.overweights);
            p.setab(true);
        }
        protected override void skill(inputin i)
        {
            base.skill(i);

            double kaku = this.p.Acore.nasukaku(i.x, i.y);
            

            var m = new motion();
            m.addmoves(new Kscalechangeman(5, "", s.Tsize, s.Tsize, 0, true, false, true));
            m.addmoves(new Kscalechangeman(5, "", 1, 1));
            this.c.addmotion(m);

            hyoji.playoto("darkhassya");
            float kyo = Math.Min(p.c.kyori(i.x,i.y),s.dam * Math.Max(p.s.speed, 0));

            new effectchara(p.hyoji, 40, p.c).addmotion(new Kopaman(40, "", 0));

            p.c.idouxy(kyo * (float)Math.Cos(kaku), kyo * (float)Math.Sin(kaku));
            p.setab(false);
            p.zurentekiyou(p.EM.overweights);
            p.setab(true);

        }
    }
}
