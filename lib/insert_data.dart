import './helpers/database_helper.dart';
import './models/actor.dart';
import './models/genre.dart';
import './models/movie.dart';
import './models/movie_actor.dart';
import './models/movie_genre.dart';
import './models/movie_producer.dart';
import './models/producer.dart';
import './models/role.dart';

Future<void> insertInitialData() async {
  final dbHelper = DatabaseHelper();

var movie = Movie(
title: 'Civil War',
year: 2024 ,
plot: "In the near future, a group of war journalists attempt to survive while reporting the truth as the United States stands on the brink of civil war.",
duration: '145 min',
photoPath: 'lib/images/movies/sh7Rg8Er3tFcN9BpKIPOMvALgZd.jpg',
);

await dbHelper.insertMovie(movie);
try {


var genre1 = Genre(name:'War');
var id_Gen1 = await dbHelper.getGenre(genre1.name);
 var movieGenre1 = GenreMovie(idMovie: 1, idGenre: id_Gen1.id!); 
 await dbHelper.insertGenreMovie(movieGenre1);
var genre2 = Genre(name:'Action');
var id_Gen2 = await dbHelper.getGenre(genre2.name);
 var movieGenre2 = GenreMovie(idMovie: 1, idGenre: id_Gen2.id!); 
 await dbHelper.insertGenreMovie(movieGenre2);
var genre3 = Genre(name:'Drama');
var id_Gen3 = await dbHelper.getGenre(genre3.name);
 var movieGenre3 = GenreMovie(idMovie: 1, idGenre: id_Gen3.id!); 
 await dbHelper.insertGenreMovie(movieGenre3);

var producer0 = Producer(
name: 'Andrew Macdonald',
bio: "",
photoPath: 'lib/images/producers/None.png',
);
var id_producer0 = await dbHelper.getOrInsertProducer(producer0);
 var movieProducer0 = MovieProducer(idMovie: 1, idProducer: id_producer0.id!);
 await dbHelper.insertMovieProducer(movieProducer0);

var producer1 = Producer(
name: 'Allon Reich',
bio: "",
photoPath: 'lib/images/producers/None.png',
);
var id_producer1 = await dbHelper.getOrInsertProducer(producer1);
 var movieProducer1 = MovieProducer(idMovie: 1, idProducer: id_producer1.id!);
 await dbHelper.insertMovieProducer(movieProducer1);

var producer2 = Producer(
name: 'Gregory Goodman',
bio: "",
photoPath: 'lib/images/producers/None.png',
);
var id_producer2 = await dbHelper.getOrInsertProducer(producer2);
 var movieProducer2 = MovieProducer(idMovie: 1, idProducer: id_producer2.id!);
 await dbHelper.insertMovieProducer(movieProducer2);

Cast:

var role0= Role(name:'Lee');
int idRole0 = await dbHelper.insertRole(role0);
var actor0 = Actor(
name: 'Kirsten Dunst',
bio: 'Point Pleasant, New Jersey, USA',
photoPath: 'lib/images/actors/6RAAxI4oPnDMzXpXWgkkzSgnIAJ.jpg',
birthdate: '1982-04-30',
bibliography: "Kirsten Caroline Dunst (born April 30, 1982) is an American actress. She has received various accolades, including a Cannes Film Festival Award for Best Actress, in addition to nominations for an Academy Award, a Primetime Emmy Award, and four Golden Globe Awards. She made her acting debut in the short Oedipus Wrecks directed by Woody Allen in the anthology film New York Stories (1989). She then gained recognition for her role as child vampiress Claudia in the horror film Interview with the Vampire (1994), which earned her a Golden Globe nomination for Best Supporting Actress. She also had roles in her youth in Little Women (1994) and the fantasy films Jumanji (1995) and Small Soldiers (1998).In the late 1990s, Dunst transitioned to leading roles in a number of teen films, including the political satire Dick (1999) and the Sofia Coppola-directed drama The Virgin Suicides (1999). In 2000, she starred in the lead role in the cheerleading film Bring It On, which has become a cult classic. She gained further wide attention for her role as Mary Jane Watson in Sam Raimi's Spider-Man (2002) and its sequels Spider-Man 2 (2004) and Spider-Man 3 (2007). Her career progressed with a supporting role in Eternal Sunshine of the Spotless Mind (2004), followed by a lead role in Cameron Crowe's tragicomedy Elizabethtown (2005), and as the title character in Coppola's Marie Antoinette (2006).In 2011, Dunst starred as a depressed newlywed in Lars von Trier's science fiction drama Melancholia, which earned her the Cannes Film Festival Award for Best Actress. In 2015, she played Peggy Blumquist in the second season of the FX series Fargo, which earned Dunst a Primetime Emmy Award nomination. She then had a supporting role in the film Hidden Figures (2016) and leading roles in The Beguiled (2017), and the black comedy series On Becoming a God in Central Florida (2019), for which she received a third Golden Globe nomination. She earned nominations for her fourth Golden Globe and first Academy Award nomination for her performance in the psychological drama The Power of the Dog (2021).",
);
 Actor actorInstance0 = await dbHelper.getOrInsertActor(actor0);
var movieActor0 = MovieActor(idMovie: 1, idActor: actorInstance0.id!, idRole: idRole0);
await dbHelper.insertMovieActor(movieActor0);

var role1= Role(name:'Joel');
int idRole1 = await dbHelper.insertRole(role1);
var actor1 = Actor(
name: 'Wagner Moura',
bio: 'Rodelas, Bahia, Brazil',
photoPath: 'lib/images/actors/6gcfwvOueJKhDpTP9KLGuWz0Hk4.jpg',
birthdate: '1976-06-27',
bibliography: "Wagner Maniçoba de Moura (born June 27, 1976) is a Brazilian actor, director and musician. Critically considered one of the protagonists of current Brazilian cinema. He is internationally recognized for the role of Pablo Escobar in the TV series Narcos and Nationally known for the role of Captain Nascimento in the TV movie Tropa de Elite and Tropa de Elite 2: The Enemy Now is Another. He started doing theater in Salvador, where he worked with renowned directors, such as Fernando Guerreiro and Celso Júnior, and soon had some participation in films. In 2003, he starred in Deus é Brasileiro and O Caminho das Nuvens, besides having a prominent role in Carandiru, which propelled him to the main scene of Brazilian cinema. He continued starring in national feature films, including the blockbusters Tropa de Elite and Tropa de Elite 2, with the famous character Captain / Colonel Nascimento. In 2007, he was the antagonist of the soap opera Paraíso Tropical, being praised for his performance by both the public and critics.",
);
 Actor actorInstance1 = await dbHelper.getOrInsertActor(actor1);
var movieActor1 = MovieActor(idMovie: 1, idActor: actorInstance1.id!, idRole: idRole1);
await dbHelper.insertMovieActor(movieActor1);

var role2= Role(name:'Jessie');
int idRole2 = await dbHelper.insertRole(role2);
var actor2 = Actor(
name: 'Cailee Spaeny',
bio: 'Springfield, Missouri, USA',
photoPath: 'lib/images/actors/s5g2fFEOfEvWAFTwtQfgbr8Od3z.jpg',
birthdate: '1997-07-24',
bibliography: "Cailee Spaeny (born July 24, 1998) is an American actress. Her first major role was in the science fiction action film Pacific Rim: Uprising (2018), which was followed by appearances in Bad Times at the El Royale, On the Basis of Sex, and Vice the same year. She also portrayed the lead of the supernatural horror film The Craft: Legacy (2020). On television, Spaeny was a series regular on the FX science fiction thriller Devs (2020) and the HBO crime drama Mare of Easttown (2021). Her biggest role came as the role of Priscilla Presley in Sofia Coppola's Priscilla (2023).",
);
 Actor actorInstance2 = await dbHelper.getOrInsertActor(actor2);
var movieActor2 = MovieActor(idMovie: 1, idActor: actorInstance2.id!, idRole: idRole2);
await dbHelper.insertMovieActor(movieActor2);

var role3= Role(name:'Sammy');
int idRole3 = await dbHelper.insertRole(role3);
var actor3 = Actor(
name: 'Stephen McKinley Henderson',
bio: 'Kansas City, Missouri, USA',
photoPath: 'lib/images/actors/z2weSPo4sdMNj47tP5o0me41r2z.jpg',
birthdate: '1949-08-31',
bibliography: "Stephen McKinley Henderson (born August 31, 1949) is an American actor. He is best known for playing Omar York in the television drama, New Amsterdam, which ran for one season in 2008. His notable film roles include portraying Arthur in Everyday People (2004), Lester in Tower Heist (2011), Father Leviatch in Lady Bird (2017), and Thufir Hawat in Dune (2021).",
);
 Actor actorInstance3 = await dbHelper.getOrInsertActor(actor3);
var movieActor3 = MovieActor(idMovie: 1, idActor: actorInstance3.id!, idRole: idRole3);
await dbHelper.insertMovieActor(movieActor3);

var role4= Role(name:'Tony');
int idRole4 = await dbHelper.insertRole(role4);
var actor4 = Actor(
name: 'Nelson Lee',
bio: 'Taipei, Taiwan',
photoPath: 'lib/images/actors/3zKvaCGrZnxQLnlUxnCITeMp86K.jpg',
birthdate: '1975-10-16',
bibliography: "Nelson Lee (born October 16, 1975 in Taipei, Taiwan) is a Taiwanese-Canadian actor raised in Saint John, New Brunswick.",
);
 Actor actorInstance4 = await dbHelper.getOrInsertActor(actor4);
var movieActor4 = MovieActor(idMovie: 1, idActor: actorInstance4.id!, idRole: idRole4);
await dbHelper.insertMovieActor(movieActor4);

var role5= Role(name:'President');
int idRole5 = await dbHelper.insertRole(role5);
var actor5 = Actor(
name: 'Nick Offerman',
bio: 'Joliet, Illinois, USA',
photoPath: 'lib/images/actors/tDzCAAJinH4Xt3lSKsajfiTyRK9.jpg',
birthdate: '1970-06-26',
bibliography: "Nicholas Offerman (born June 26, 1970) is an American actor, writer, comedian, producer, and woodworker. He is best known for his role as Ron Swanson in the NBC sitcom Parks and Recreation, for which he received the Television Critics Association Award for Individual Achievement in Comedy and was twice nominated for the Critics' Choice Television Award for Best Supporting Actor in a Comedy Series. Offerman is also known for his role in The Founder, in which he portrays Richard McDonald, one of the brothers who developed the fast food chain McDonald's. His first major television role since the end of Parks and Recreation was as Karl Weathers in the FX series Fargo, for which he received a Critics' Choice Television Award nomination for Best Supporting Actor in a Movie/Miniseries. Since 2018, Offerman has co-hosted the NBC reality competition series, Making It, with Amy Poehler.",
);
 Actor actorInstance5 = await dbHelper.getOrInsertActor(actor5);
var movieActor5 = MovieActor(idMovie: 1, idActor: actorInstance5.id!, idRole: idRole5);
await dbHelper.insertMovieActor(movieActor5);

var role6= Role(name:'Dave');
int idRole6 = await dbHelper.insertRole(role6);
var actor6 = Actor(
name: 'Jefferson White',
bio: 'Mount Vernon, Iowa, USA',
photoPath: 'lib/images/actors/8QSrhrWpqTBGJN3rfijXCvmOcb5.jpg',
birthdate: '1989-11-03',
bibliography: "Jefferson White is an actor.",
);
 Actor actorInstance6 = await dbHelper.getOrInsertActor(actor6);
var movieActor6 = MovieActor(idMovie: 1, idActor: actorInstance6.id!, idRole: idRole6);
await dbHelper.insertMovieActor(movieActor6);


} catch (e) {
  print('Error: $e');
}

}