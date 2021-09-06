import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_bad_bloc/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_bloc/constants/my_colors.dart';
import 'package:breaking_bad_bloc/data/model/Character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  const CharacterDetailsScreen({Key? key, required this.character,}) : super(key: key);
  
  Widget buildSliverAppBar(){
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.MyBlueGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          '${character.nickname}',
          style: TextStyle(
            color: MyColors.MyWhite
          ),
          textAlign: TextAlign.start,
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(character.image, fit: BoxFit.cover,),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value){
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: MyColors.MyWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: MyColors.MyWhite,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent){
    return Divider(
      height: 30,
      color: MyColors.MyBlueGrey,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state){
    if(state is QuotesLoaded){
      return displayRandomQuoteOrEmptySpace(state);
    }else{
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(state){
    var quotes = (state).quotes;
    if(quotes.length != 0){
      int randomQuoteIndex = Random().nextInt(quotes.length -1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: MyColors.MyWhite,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: MyColors.MyBlueGrey,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              FlickerAnimatedText(
                quotes[randomQuoteIndex].quote,
                textAlign: TextAlign.center,
              ),
            ],
            repeatForever: true,
            isRepeatingAnimation: true,
          ),
        ),
      );
    }
    else{
      return Container();
    }
  }

  Widget showProgressIndicator(){
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.MyBlueGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).fetchQuotes(character.name);
    return Scaffold(
      backgroundColor: MyColors.MyDarkGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 200,
                            height: 100,
                            child: Image.asset('assets/images/scrollDown.gif',fit: BoxFit.cover,)),
                      ),
                      characterInfo('Job :  ', character.jobs.join(' / ')),
                      buildDivider(280),
                      characterInfo('Appeared in :  ', character.category),
                      buildDivider(210),
                      characterInfo('Seasons :  ', character.breakingBadAppearance.join(' / ')),
                      buildDivider(240),
                      characterInfo('Status :  ', character.status),
                      buildDivider(255),
                      character.betterCallSaulAppearance.isEmpty? Container():
                      characterInfo('Better Call Saul Seasons :  ', character.betterCallSaulAppearance.join(' / ')),
                      character.betterCallSaulAppearance.isEmpty? Container():
                      buildDivider(105),
                      characterInfo('Actor/Actress :  ', character.name),
                      buildDivider(195),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<CharactersCubit, CharactersState>(
                          builder: (context, state){
                            return checkIfQuotesAreLoaded(state);
                          }),
                      SizedBox(
                        height: 380,
                      ),
                    ],
                  ),
                ),
              ]
            ),
            ),
        ],
      ),
    );
  }
}
