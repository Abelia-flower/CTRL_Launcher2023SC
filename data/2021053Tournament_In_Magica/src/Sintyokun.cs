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
using THE_Tournament.relic;
using THE_Tournament.scene;
using THE_Tournament.wepon;

namespace THE_Tournament
{
    enum itemtype 
    {
    wepon,util,relic,random
    }
    [Serializable]
    class Sintyokun
    {
        int fase = 0;
        public int Fase { get { return fase; } }

        public int Money { get { return (int)Math.Round(Math.Pow(fase,1.3)); } }
        public void resetfase() { fase = 0; }
        public void enfase() { fase += 1; }

        public List<itemcard> getcards(float width, rank r)
        {
            float bogoper = 70, bubbleper = 20, timper = 10;

            switch (r)
            {
                case rank.bogo:
                    bogoper = 60;
                    bubbleper = 30;
                    timper = 10;
                    break;
                case rank.bubble:
                    bogoper = 25;
                    bubbleper = 60;
                    timper = 15;
                    break;
                case rank.tim:
                    bogoper = 10;
                    bubbleper = 30;
                    timper = 60;
                    break;
                default:
                    break;
            }
            rank nr; int cou;
            float mmm = fileman.r.Next() % (bogoper + bubbleper + timper);
            if (mmm < bogoper)
            {
                cou = 5;

                nr = rank.bogo;
            }
            else if (mmm < bogoper + bubbleper)
            {
                cou = 4;
                nr = rank.bubble;
            }
            else
            {
                cou = 3;
                nr = rank.tim;

            }


            var cards = new List<itemcard>();
            foreach (var a in getstdwepons(stdbai(), nr))
            {

                cards.Add(new itemcard(width, a, nr));
            }
            foreach (var a in getstdutils(stdbai(), nr))
            {
                cards.Add(new itemcard(width, a, nr));
            }



            {
                List<itemcard> relicards = new List<itemcard>();
                foreach (var a in getstdrelics(nr))
                {

                    relicards.Add(new itemcard(width, a, nr));

                }
                /* while (relicards.Count > cards.Count / 2)
                 {
                     relicards.RemoveAt(fileman.r.Next() % relicards.Count());
                 }*/
                cards.AddRange(relicards);
            }
            while (cards.Count > cou)
            {
                cards.RemoveAt(fileman.r.Next() % cards.Count());
            }
            return cards;
        }
        public testtreasure genetreasure(player p, SceneManager sm, Scene next, rank r)
        {
            List<treasure> lis = new List<treasure>();
            float kaku = fileman.r.Next() % 100;
            if (fileman.percentin(80))
            {
                lis.Add(new treasure(rank.bogo, itemtype.relic, 5, stdbai()));
            }
            else 
            {

                lis.Add(new treasure(rank.bogo, itemtype.relic, 3, stdbai()));
                lis.Add(new treasure(rank.bubble, itemtype.relic, 3, stdbai()));
            }
            switch (r)
            {
                case rank.bogo:

                    if (kaku < 70)
                    {
                        if (kaku < 35)
                        {
                            lis.Add(new treasure(rank.bogo, itemtype.random, 4, stdbai()));
                        }
                        else if (kaku < 60)
                        {
                            lis.Add(new treasure(rank.bogo, itemtype.wepon, 2, stdbai()));
                            lis.Add(new treasure(rank.bogo, itemtype.relic, 2, stdbai()));
                            lis.Add(new treasure(rank.bogo, itemtype.util, 1, stdbai()));
                        }
                        else
                        {
                            lis.Add(new treasure(rank.bogo, itemtype.random, 2, stdbai()));
                            lis.Add(new treasure(rank.bogo, itemtype.random, 2, stdbai()));
                        }
                    }
                    else if (kaku < 90)
                    {
                        lis.Add(new treasure(rank.bubble, itemtype.random, 3, stdbai()));
                    }
                    else
                    {
                        lis.Add(new treasure(rank.tim, itemtype.random, 1, stdbai()));
                    }
                    break;
                case rank.bubble:
                    if (kaku < 20)
                    {

                        lis.Add(new treasure(rank.bogo, itemtype.wepon, 5, stdbai()));
                        lis.Add(new treasure(rank.bogo, itemtype.random, 5, stdbai()));
                        lis.Add(new treasure(rank.bogo, itemtype.relic, 5, stdbai()));

                    }
                    else if (kaku < 90)
                    {
                        if (kaku < 55)
                        {
                            lis.Add(new treasure(rank.bubble, itemtype.random, 4, stdbai()));
                        }
                        else if (kaku < 80)
                        {
                            lis.Add(new treasure(rank.bubble, itemtype.wepon, 2, stdbai()));
                            lis.Add(new treasure(rank.bubble, itemtype.relic, 2, stdbai()));
                            lis.Add(new treasure(rank.bubble, itemtype.util, 1, stdbai()));
                        }
                        else
                        {
                            lis.Add(new treasure(rank.bubble, itemtype.random, 2, stdbai()));
                            lis.Add(new treasure(rank.bubble, itemtype.random, 2, stdbai()));
                        }
                    }
                    else
                    {
                        lis.Add(new treasure(rank.tim, itemtype.random, 2, stdbai()));
                    }
                    break;
                case rank.tim:
                    if (kaku < 20)
                    {

                        lis.Add(new treasure(rank.bubble, itemtype.wepon, 5, stdbai()));
                        lis.Add(new treasure(rank.bubble, itemtype.random, 5, stdbai()));
                        lis.Add(new treasure(rank.bubble, itemtype.relic, 5, stdbai()));

                    }
                    else
                    {
                        if (kaku < 55)
                        {
                            lis.Add(new treasure(rank.tim, itemtype.random, 4, stdbai()));
                        }
                        else if (kaku < 80)
                        {
                            lis.Add(new treasure(rank.tim, itemtype.wepon, 2, stdbai()));
                            lis.Add(new treasure(rank.tim, itemtype.relic, 2, stdbai()));
                            lis.Add(new treasure(rank.tim, itemtype.util, 1, stdbai()));
                        }
                        else
                        {
                            lis.Add(new treasure(rank.tim, itemtype.random, 2, stdbai()));
                            lis.Add(new treasure(rank.tim, itemtype.random, 2, stdbai()));
                        }
                    }
                    break;
                default:
                    break;
            }
            return new testtreasure(p, lis, next, sm);
        }

        public List<itemcard> getcards(float width, rank r, float bai, itemtype type, int cou)
        {
            var res = new List<itemcard>();
            while (res.Count < cou)
            {
                switch (type)
                {
                    case itemtype.wepon:
                        foreach (var a in getstdwepons(bai, r))
                        {
                            res.Add(new itemcard(width, a, r));
                        }
                        break;
                    case itemtype.util:
                        foreach (var a in getstdutils(bai, r))
                        {
                            res.Add(new itemcard(width, a, r));
                        }
                        break;
                    case itemtype.relic:
                        foreach (var a in getstdrelics(r))
                        {
                            res.Add(new itemcard(width, a, r));
                        }
                        break;
                    case itemtype.random:
                        foreach (var a in getstdwepons(bai, r))
                        {
                            res.Add(new itemcard(width, a, r));
                        }
                        foreach (var a in getstdutils(bai, r))
                        {
                            res.Add(new itemcard(width, a, r));
                        }
                        foreach (var a in getstdrelics(r))
                        {
                            res.Add(new itemcard(width, a, r));
                        }
                        break;
                    default:
                        foreach (var a in getstdwepons(bai, r))
                        {
                            res.Add(new itemcard(width, a, r));
                        }

                        break;
                }
            }
            while (res.Count > cou)
            {
                res.RemoveAt(fileman.r.Next() % res.Count());
            }
            return res;
        }
        public float stdbai(float kyo = 1) { return Sintyokun.stdbai(fase,kyo); }
        static public float stdbai(int fase,float kyo = 1) { return Math.Max(1, 1 + (float)Math.Pow(fase,1.2f) / 20f * (kyo)); }
        public static List<Wepon> getstdutils(float bai, rank r)
        {
            var res = new List<Wepon>();
            switch (r)
            {
                case rank.bogo:

                    res.Add(new jumper( Weponstatus.WSFromParam("jumper", new List<zokusei> { zokusei.physical },skill:1/bai)));

                    break;
                case rank.bubble:
                    res.Add(new kasoker(Weponstatus.WSFromParam( "kasokar", new List<zokusei> { zokusei.physical }, skill: 1 / bai)));

                    break;
                case rank.tim:
                    res.Add(new warper(Weponstatus.WSFromParam("warper", new List<zokusei> { zokusei.physical }, skill: 1 / bai)));

                    break;
                default:
                    break;
            }

            foreach (var a in res) a.power = bai;
            return res;
        }

        public static List<Wepon> getstdwepons(float bai,rank r)
        {
            var res = new List<Wepon>();
            switch (r)
            {
                case rank.bogo:

            //        res.Add(new timshot(Weponstatus.WSFromParam("timshot", new List<zokusei> { zokusei.physical },dam:bai)));
                    res.Add(new timarm(Weponstatus.WSFromParam("timarm", new List<zokusei> { zokusei.physical }, dam: bai)));
                    res.Add(new firerod(Weponstatus.WSFromParam("firerod", dam:bai)));
                    res.Add(new icerod(Weponstatus.WSFromParam("icerod", dam:bai)));
                    res.Add(new thunderrod(Weponstatus.WSFromParam("thunderrod", dam:bai)));
                    res.Add(new windrod(Weponstatus.WSFromParam("windrod", dam:bai)));
                    res.Add(new earthrod(Weponstatus.WSFromParam("earthrod", dam:bai)));
                    res.Add(new lightrod(Weponstatus.WSFromParam("lightrod", dam:bai)));
                    res.Add(new darkrod(Weponstatus.WSFromParam("darkrod", dam:bai)));
                    break;
                case rank.bubble:

                    res.Add(new timwand(Weponstatus.WSFromParam("timwand", new List<zokusei> { zokusei.physical, zokusei.physical}, dam: bai)));
                    res.Add(new firewand(Weponstatus.WSFromParam("firewand", dam:bai)));
                    res.Add(new icewand(Weponstatus.WSFromParam("icewand", dam:bai)));
                    res.Add(new windwand(Weponstatus.WSFromParam("windwand", dam:bai)));
                    res.Add(new earthwand(Weponstatus.WSFromParam("earthwand", dam:bai)));
                    res.Add(new thunderwand(Weponstatus.WSFromParam("thunderwand", dam:bai)));
                    res.Add(new lightwand(Weponstatus.WSFromParam("lightwand", dam:bai)));
                    res.Add(new darkwand(Weponstatus.WSFromParam("darkwand", dam:bai)));
                    break;
                case rank.tim:

                    res.Add(new timcane(Weponstatus.WSFromParam("timcane", new List<zokusei> { zokusei.physical, zokusei.physical, zokusei.physical }, dam: bai)));
                    res.Add(new firecane(Weponstatus.WSFromParam("firecane", dam:bai)));
                    res.Add(new icecane(Weponstatus.WSFromParam("icecane", dam:bai)));
                    res.Add(new windcane(Weponstatus.WSFromParam("windcane", dam:bai)));
                    res.Add(new earthcane(Weponstatus.WSFromParam("earthcane", dam:bai)));
                    res.Add(new thundercane(Weponstatus.WSFromParam("thundercane", dam:bai)));
                    res.Add(new lightcane(Weponstatus.WSFromParam("lightcane", dam:bai)));
                    res.Add(new darkcane(Weponstatus.WSFromParam("darkcane", dam:bai)));
                    
                    break;
                case rank.def:
                    res.Add(new star(Weponstatus.WSFromParam("star", dam:bai)));
                    res.Add(new atom(Weponstatus.WSFromParam("atom", dam:bai)));
                    res.Add(new origin(Weponstatus.WSFromParam("origin", dam:bai)));
                    res.Add(new hugemagic(Weponstatus.WSFromParam("hugemagic", dam:bai)));
                    break;
                case rank.n:
                    res.Add(new firefist(Weponstatus.WSFromParam("firefist", dam: bai)));
                    res.Add(new iceedge(Weponstatus.WSFromParam("iceedge", dam: bai)));
                    res.Add(new windsound(Weponstatus.WSFromParam("windsound", dam: bai)));
                    res.Add(new eartharm(Weponstatus.WSFromParam("eartharm", dam: bai)));
                    res.Add(new thundersphere(Weponstatus.WSFromParam("thundersphere", dam: bai)));
                    res.Add(new lightclaw(Weponstatus.WSFromParam("lightclaw", dam: bai)));
                    res.Add(new darksword(Weponstatus.WSFromParam("darksword", dam: bai)));
                    res.Add(new oursoul(Weponstatus.WSFromParam("oursoul", dam: bai)));
                    break;
                default:
                    break;
            }
            foreach (var a in res) a.power = bai;
            return res;
        }
        public static T getonesoubihin<T>(T s)
            where T:soubihin
        {
            if (s == null) return null;
            var lis = getstdrelics(rank.bogo);
            lis.AddRange(getstdrelics(rank.bubble));
            lis.AddRange(getstdrelics(rank.tim));
            foreach (var a in lis)
            {
                if (typeof(T) == a.GetType())
                {
                    var b = (soubihin)a;
                    if (b.name == ((soubihin)s).name)
                    {
                        return (T)a;
                    }
                }
            }
            return null;
        }
        public static T getonerelic<T>(T s=null)
            where T:Relic
        {
            if (typeof(T) == typeof(soubihin)) 
            {
                return (T)(Relic)getonesoubihin((soubihin)(Relic)s);
            }
                var lis = getstdrelics(rank.bogo);
                lis.AddRange(getstdrelics(rank.bubble));
                lis.AddRange(getstdrelics(rank.tim));
                foreach (var a in lis)
                {
                    if (typeof(T) == a.GetType())
                    {
                        return (T)a;
                    }
                } 
            return null;
        }
        public static List<Relic> getstdrelics(rank r)
        {
            var res = new List<Relic>();
            switch (r)
            {
                case rank.bogo:
                    res.Add(new soubihin("healthorb", new PlayerStatus(FP.PR("healthorb")+ FP.PR("healthorbP"))));
                    res.Add(new soubihin("speedorb", new PlayerStatus(FP.PR("speedorb"), speed: FP.PR("speedorbP"))));
                    res.Add(new soubihin("damorb", new PlayerStatus(FP.PR("damorb"), dam: FP.PR("damorbP"))));
                    res.Add(new soubihin("sizeorb", new PlayerStatus(FP.PR("sizeorb"), size: FP.PR("sizeorbP"))));
                    res.Add(new soubihin("jizokuorb", new PlayerStatus(FP.PR("jizokuorb"), jizoku: FP.PR("jizokuorbP"))));
                    res.Add(new soubihin("coolorb", new PlayerStatus(FP.PR("coolorb"), cool: FP.PR("coolorbP"))));
                    res.Add(new soubihin("skillorb", new PlayerStatus(FP.PR("skillorb"), skill: FP.PR("skillorbP"))));
                    break;
                case rank.bubble:
                    res.Add(new firesign(FP.PR("firesign",0), FP.PR("firesign",1)));
                    res.Add(new icesign(FP.PR("icesign", 0), FP.PR("icesign", 1)));
                    res.Add(new windsign(FP.PR("windsign", 0), FP.PR("windsign", 1)));
                    res.Add(new earthsign(FP.PR("earthsign", 0), FP.PR("earthsign", 1)));
                    res.Add(new thundersign(FP.PR("thundersign", 0), FP.PR("thundersign", 1)));
                    res.Add(new lightsign(FP.PR("lightsign", 0), FP.PR("lightsign", 1)));
                    res.Add(new darksign(FP.PR("darksign", 0), FP.PR("darksign", 1)));

                    break;
                case rank.tim:
                    res.Add(new soubihin("nikuno_yuujou",PlayerStatus.PSFromParam("nikuno_yuujou")));
                    res.Add(new SoUnd(FP.PR("SoUnd")));
                    res.Add(new unmatch((int)FP.PR("unmatch",1)));
                    break;
                default:

                    break;
            }
          
         
           

            return res;
        }
        static public player getstdplayer(string atag="me",string tex="tim\\body",float si=1)
        {
            var rec = new ABrecipie(new List<string> { "", "body" }, new List<Shape> { new Circle(0, 0, 0, 0, 0), new Circle(0, 0, 0, 0, 0) });
            var p = new player(new PlayerStatus(500, 4, 1, 1, 1, 2, 1), character.onepicturechara(tex, 32*si)
             , rec, new buturiinfo(100, 0.08f, 0.2f, 0, 0, 0, 0, 1, atag));
            p.autoskill = false;

            new weponslot(p.c.w * 0.5f, p.c.h * -0.5f, 1).addweponslot(p);

            new weponslot(p.c.w * 0.1f, p.c.h * 0, 1).addweponslot(p);
            new weponslot(p.c.w * 0.9f, p.c.h * 0, 1).addweponslot(p);
            new weponslot(p.c.w * -0.05f, p.c.h * 1, 1).addweponslot(p);
            new weponslot(p.c.w * 1.05f, p.c.h * 1, 1).addweponslot(p);
            return p;

        }
        protected float enebai(float hani) 
        {
            return stdbai(fase,Math.Min((fileman.whrandhani(hani)+(100-hani))/100,1));
        }
        public List<player> getenemy(int cou)
        {
            var res = new List<player>();
            for (int i = 0; i < cou; i++)
            {
                if (fileman.percentin(Math.Max(70 - fase * fase * 1.5f, 0)))
                {
                    res.Add(getstdenemy(enebai(80 - fase * fase), Math.Min(fase + 2, 4), (int)Math.Max((fase - 2) * 0.4f, 0), Math.Max(fase - 1, 0), rank.bogo));
                }
                else if (fileman.percentin(Math.Max(70 - fase * fase * 0.8f, 0)))
                {
                    res.Add(getstdenemy(enebai(80 - fase * fase), Math.Min(fase + 2, 4), (int)Math.Max((fase - 1) * 0.5f, 0), Math.Max(fase, 0), rank.bubble));
                }
                else
                {

                    res.Add(getstdenemy(enebai(80 - fase * fase), Math.Min(fase + 2, 4), (int)Math.Max((fase - 0) * 0.6f, 0), Math.Max(fase + 1, 0), rank.tim));

                }
            }
            return res;
        }

        public static player getstdenemy(float bai,int weps,int relic,int status,rank r) 
        {
            var rec = new ABrecipie(new List<string> { "", "core" }, new List<Shape> { new Circle(0, 0, 0, 0, 0), new Circle(0, 0, 0, 0, 0) });

            var he = new player(new PlayerStatus(500, 4, 1, 1, 0.8f, 2, 1), character.onepicturechara("enemy\\"+r.ToString(), 32)
                , rec, new buturiinfo(100, 0.08f, 0.2f, 0, 0, 0, 0, 1, "he"));
            he.c.settxy(100, 0);
            {

                new weponslot(he.c.w * 0.5f, he.c.h * -0.5f, 1).addweponslot(he);
                var lis = new List<Wepon>();
                switch (r)
                {
                    case rank.bogo:
                        if (fileman.percentin(70))
                        {
                            lis = getstdutils(bai, rank.bogo);
                        }
                        else
                        {
                            lis = getstdutils(bai, rank.bubble);
                        }
                        break;
                    case rank.bubble:
                        if (fileman.percentin(40))
                        {
                            lis = getstdutils(bai, rank.bogo);
                        }
                        else if (fileman.percentin(80))
                        {
                            lis = getstdutils(bai, rank.bubble);
                        }
                        else 
                        {
                            lis = getstdutils(bai, rank.tim);
                        }
                        break;
                    case rank.tim:
                        if (fileman.percentin(10))
                        {
                            lis = getstdutils(bai, rank.bogo);
                        }
                        else if (fileman.percentin(50))
                        {
                            lis = getstdutils(bai, rank.bubble);
                        }
                        else
                        {
                            lis = getstdutils(bai, rank.tim);
                        }
                        break;
                    default:
                        break;
                }
                lis[fileman.r.Next() % lis.Count].soubi(he);
            }

            new weponslot(he.c.w * 0.1f, he.c.h * 0, 1).addweponslot(he);
            new weponslot(he.c.w * 0.9f, he.c.h * 0, 1).addweponslot(he);
            new weponslot(he.c.w * -0.05f, he.c.h * 1, 1).addweponslot(he);
            new weponslot(he.c.w * 1.05f, he.c.h * 1, 1).addweponslot(he);

            for (int i = 0; i < weps; i++)
            {

                var lis = new List<Wepon>();
                switch (r)
                {
                    case rank.bogo:
                        lis = getstdwepons(bai, rank.bogo);
                        break;
                    case rank.bubble:
                        if (fileman.percentin(70-relic*relic*2))
                        {
                            lis = getstdwepons(bai, rank.bogo);
                        }
                        else 
                        {
                            lis = getstdwepons(bai, rank.bubble);
                        }
                        break;
                    case rank.tim:
                        if (fileman.percentin(30 - relic*relic))
                        {
                            lis = getstdwepons(bai, rank.bogo);
                        }
                        else if (fileman.percentin(70 - relic *relic*1.3f))
                        {
                            lis = getstdwepons(bai, rank.bubble);
                        }
                        else if ( fileman.percentin(100 - relic * relic))
                        {
                            lis = getstdwepons(bai, rank.tim);
                        }
                        else if ( fileman.percentin(100 - relic*relic*0.7f ))
                        {
                            lis = getstdwepons(bai, rank.def);
                        }
                        else 
                        {
                            lis = getstdwepons(bai, rank.n);
                        }
                        break;
                    default:
                        break;
                }
                getstdwepons(bai,r);
                lis[fileman.r.Next() % lis.Count].soubi(he);
                //  new timarm(new Weponstatus(180, 15, 1, 15)).soubi(he);
            }
            {
                var lis = new List<Relic>();
                for (int i = 0; i < status; i++)
                {
                    lis.AddRange(getstdrelics(rank.bogo));
                }
                for (int i = 0; i < status; i++)
                {
                    if (fileman.percentin(relic - 13))
                    {

                        getonesoubihin(new soubihin("nikuno_yuujou", new PlayerStatus())).add(he);
                        
                    }
                    else
                    {
                        int aa = fileman.r.Next() % lis.Count();
                        lis[aa].add(he);
                        lis.RemoveAt(aa);
                    }
                }
            }
            for (int i = 0; i < relic; i++) 
            {
                if (fileman.percentin(70+relic*3))
                {
                    List<Relic> lis = new List<Relic>();
                    switch (r)
                    {
                        case rank.bogo:
                            if (fileman.percentin(80))
                            {
                                lis = getstdrelics(rank.bogo);
                            }
                            else
                            {
                                lis = getstdrelics(rank.bubble);
                            }
                            break;
                        case rank.bubble:
                            if (fileman.percentin(50))
                            {
                                lis = getstdrelics(rank.bogo);
                            }
                            else if (fileman.percentin(70))
                            {
                                lis = getstdrelics(rank.bubble);
                            }
                            else
                            {
                                lis = getstdrelics(rank.tim);
                            }
                            break;
                        case rank.tim:
                            if (fileman.percentin(30))
                            {
                                if (fileman.percentin(relic-10))
                                {
                                    lis = getstdrelics(rank.bogo);
                                }
                                else 
                                {
                                    lis = new List<Relic>();
                                    lis.Add(getonesoubihin(new soubihin("nikuno_yuujou",new PlayerStatus())));
                                }
                            }
                            else if (fileman.percentin(50))
                            {
                                lis = getstdrelics(rank.bubble);
                            }
                            else
                            {
                                lis = getstdrelics(rank.tim);
                            }
                            break;
                        default:
                            break;
                    }

                    lis[fileman.r.Next() % lis.Count()].add(he);
                }
            }
            return he;
        }
        public static List<zokusei> tyusituzokusei(List<Wepon> w)
        {
            var zs = new List<zokusei>();
            foreach (var a in w) { zs.AddRange(a.s.Z); }
            while (zs.Contains(zokusei.energy))
            {
                zs.Remove(zokusei.energy);
            }
            return zs;
        }
        public static float tyusitupower(List<Wepon> w)
        {
            if (w.Count == 0) return 0;
            if (w.Count == 1) return w[0].power-1;
            var zs = 0.0f;
            float min = w[0].power-1;
            float max = w[0].power-1;
            foreach (var a in w) { max =Math.Max(max,a.power-1); min = Math.Max(Math.Min(min, a.power-1),0); }
            foreach (var a in w) { zs += (float)a.power-1; }


            float up= (float)Math.Sqrt(zs - min+1)-1 + min;
            float hosyo= min + (max - min) / 2;

       //     Console.WriteLine(up+" skjal "+zs+" as;dl: "+min+" min max "+max+" s;dla: "+hosyo);
            return Math.Max(up ,hosyo);
        }
        static public Wepon getonewepon(Wepon w,float bai) 
        {
            var lis = new List<Wepon>();
            lis = getstdwepons(bai , rank.tim);
            lis.AddRange(getstdwepons(bai, rank.bubble));
            lis.AddRange(getstdwepons(bai, rank.bogo));
            lis.AddRange(getstdwepons(bai, rank.def));
            lis.AddRange(getstdwepons(bai, rank.n));
            foreach (var a in lis) 
            {
                if (w.GetType() == a.GetType()) 
                {
                    return a;
                }
            }
            return new timshot(new Weponstatus(100,100,100,100,100,new List<zokusei> {zokusei.physical }));
            
        }
        public static List<Wepon> gousei(List<Wepon> w)
        {
            var zs = tyusituzokusei(w);
            var kouho = new List<Wepon>();

            var lis = getstdwepons(1, rank.tim);
            lis.AddRange(getstdwepons(1, rank.bubble));
            lis.AddRange(getstdwepons(1, rank.bogo));
            lis.AddRange(getstdwepons(1, rank.def));
            lis.AddRange(getstdwepons(1, rank.n));
            foreach (var a in lis)
            {
                bool ok = true;
                var tzs = new List<zokusei>(zs);

                foreach (var b in a.s.Z)
                {
                    if (b != zokusei.energy)
                    {
                        ok = ok && tzs.Remove(b);
                    }
                }
                if (ok)
                {
                   // Console.WriteLine(a.getname());
                    kouho.Add(a);
                }
            }
            var aan = new List<Wepon>(kouho);
            for (int i = aan.Count - 1; i >= 0; i--)
            {
                var allz = aan[i].s.Z;
                while (allz.Remove(zokusei.energy)) ;
                for (int t = 0; t < aan.Count; t++)
                {

                    if (i != t)
                    {
                        var Z1 = aan[i].s.Z;
                        var Z2 = aan[t].s.Z;
                        while (Z1.Remove(zokusei.energy)) ;
                        while (Z2.Remove(zokusei.energy)) ;

                        if (Z1.Count < Z2.Count)
                        {

                            foreach (var a in Z2) allz.Remove(a);
                        }
                    }
                }
                if (allz.Count == 0) { kouho.RemoveAt(i); }

            }

            float bai = tyusitupower(w);

            var ZZZ = new List<zokusei>();
            foreach (var a in kouho) 
            {
                foreach (var b in a.s.Z) 
                {
                    if (b != zokusei.energy) 
                    {
                        ZZZ.Add(b);
                    }
                }
            }
            
            List<float> bais = new List<float>();
            foreach (var a in kouho) 
            {
                var z = a.s.Z;
                while (z.Remove(zokusei.energy)) ;
                bais.Add(1+bai*z.Count / ZZZ.Count);
            }
            var res = new List<Wepon>();
            for (int i = 0; i < kouho.Count; i++)
            {
                res.Add(getonewepon(kouho[i],bais[i]));
            }
            

           
          

            return res;

        }
    }

    enum rank 
    {
     bogo,bubble,tim,def,n
    }
    class itemcard
    {
        character card;
        character icon;
        List<message> text;
        Wepon w = null;
        Relic r = null;
        upgradecard u=null;

        public itemcard(float width, Wepon w,rank rr,float mojibai=1)
        {

            card = character.onepicturechara(@"card\"+rr.ToString(), width, -10);
            icon = new character(w.c);//演出追加するならメソッド化してがんばれ！
            icon.resettokijyun();
            if (icon.w > icon.h)
            {
                icon.scalechange((card.h * 0.4f) / icon.w);
                var r = new radtoman(1, "", 45, 360);
                r.start(icon);
                r.frame(icon, 1);
            }
            else if (icon.w < icon.h)
            {
                icon.scalechange((card.h * 0.4f) / icon.h);
                var r = new radtoman(1, "", -45, 360);
                r.start(icon);
                r.frame(icon, 1);
            }
            else 
            {
                icon.scalechange((card.h * 0.4f) / icon.h);
               
            }
            float si = card.w / 15*mojibai;
           
            text = message.hutidorin(si / 15, 0, 0, si, (int)(30 / mojibai - 2), 0, 0, -1, w.getname() + "\n" + w.getsetumei() + "\n" + w.s.printstatus(), 0, 0, 0, false);
            this.w = w;
        }
        public itemcard(float width, Relic r,rank rr,float mojibai=1)
        {
            card = character.onepicturechara(@"card\"+rr.ToString(), width, -10);
            icon = r.getc();
            icon.scalechange((card.h * 0.4f) / icon.h);

            float si = card.w / 15 * mojibai;
            text = message.hutidorin(si / 15, 0, 0, si, (int)(30 / mojibai - 2), 0, 0, -1, r.getname() + "\n" + r.getsetumei(), 0, 0, 0, false);
            this.r = r;
        }
        public itemcard(float width, upgradecard u,float mojibai=1)
        {
            card = character.onepicturechara(@"card\upgrade" , width, -10);
            icon = character.onepicturechara(u.tex,64);
            icon.scalechange((card.h * 0.4f) / icon.h);

            float si = card.w / 13 * mojibai;
            text = message.hutidorin(si / 15, 0, 0, si, (int)(26/mojibai - 2), 0, 0, -1, u.name + "\n" + u.setumei, 0, 0, 0, false);
            this.u = u;
        }

        public void frame(float cl) 
        {
            card.frame(cl);
            icon.frame(cl);
        }

        public bool on(inputin i)
        {
            Rectangle r = new Rectangle(0, 0);
            r.setto(card);
            return r.onhani(i.x, i.y);
        }

        public void resethyoji(hyojiman hyo)
        {
            card.resethyoji(hyo);
            icon.resethyoji(hyo);
            text.ForEach((a) => a.add(hyo));
        }

        public void sinu(hyojiman hyo)
        {
            card.sinu(hyo);
            icon.sinu(hyo);
            text.ForEach((a) => a.remove(hyo));
        }
        public void settxy(float x, float y)
        {
            card.settxy(x, y);
            icon.setcxy(card.getcx(card.tx, card.h * 0.275f), card.getcy(card.tx, card.h * 0.275f), icon.w / 2, icon.h / 2);

            float dx = (x = card.getcx(card.w * 0.05f, card.h * 0.52f)) - text[0].x;
            float dy = card.getcy(card.w * 0.05f, card.h * 0.52f) - text[0].y;
            text.ForEach((a) => { a.x += dx; a.y += dy; });

        }
        public bool getcard(player p=null,SD s=null)
        {
            if (w != null)
            {
                return w.soubi(p);
            }
            else if (r != null)
            {
                r.add(p);
                return true;
            }
            else if (u != null) 
            {
                if(s==null) return u.buy(SD.S);
                return u.buy(s);
            }
            return true;
        }
        public Wepon GetWepon() { return w; }
        public upgradecard GetUpgradecard() { return u; }

    }
   
}
