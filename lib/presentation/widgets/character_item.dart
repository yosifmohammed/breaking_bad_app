import 'package:breaking_bad_bloc/constants/Strings.dart';
import 'package:breaking_bad_bloc/constants/my_colors.dart';
import 'package:breaking_bad_bloc/data/model/Character.dart';
import 'package:flutter/material.dart';

class CharacterItem extends StatelessWidget {
  final Character character;

  const CharacterItem({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
      padding: EdgeInsetsDirectional.all(2),
      decoration: BoxDecoration(
        color: MyColors.MyYellow,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
            context,
            characterDetailsScreen,
            arguments:character
        ),
        child: GridTile(
          child: Hero(
            tag: character.charId,
            child: Container(
                color: MyColors.MyGrey,
              child: character.image.isNotEmpty?
              FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: character.image , fit: BoxFit.cover,):
              Image.asset("assets/images/error.gif"),
            ),
          ),
          footer: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: MyColors.MyBlack54,
            alignment: Alignment.bottomCenter,
            child: Text(
              '${character.name}',
              style: TextStyle(
                color: MyColors.MyWhite,
                height: 1.3,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
