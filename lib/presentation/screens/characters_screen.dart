import 'package:breaking_bad_bloc/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_bloc/constants/my_colors.dart';
import 'package:breaking_bad_bloc/data/model/Character.dart';
import 'package:breaking_bad_bloc/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedForCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField(){
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.MyBlueGrey,
      style: TextStyle(color: MyColors.MyBlueGrey, fontSize: 18),
      onChanged: (searchedCharacter){
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
      decoration: InputDecoration(
        hintText: 'Find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColors.MyBlueGrey, fontSize: 18),
      ),
    );
  }

  void addSearchedForItemsToSearchedList(String searchesCharacter){
    searchedForCharacters = allCharacters.where((character) => character.name.startsWith(searchesCharacter.toUpperCase())).toList();
    setState(() {
    });
  }

  List<Widget> _buildAppBarActions(){
    if(_isSearching){
      return [
        IconButton(onPressed: (){
          _clearSearch();
          Navigator.pop(context);
        },
        icon: Icon(Icons.clear, color: MyColors.MyBlueGrey,)),
      ];
    }else{
      return [
        IconButton(
            onPressed: startSearch,
            icon: Icon(Icons.search, color: MyColors.MyWhite,))
      ];
    }
  }

  void startSearch(){
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching(){
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch(){
    setState(() {
      _searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).fetchCharacters();
  }

  Widget buildBlocWidget(){
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state){
        if(state is CharactersLoaded){
          allCharacters = (state).characters;
          return buildLoadedListWidgets();
        }else{
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget showLoadingIndicator(){
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.MyBlueGrey,
      ),
    );
  }

  Widget buildLoadedListWidgets(){
    return SingleChildScrollView(
      child: Container(
        color: MyColors.MyGrey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 2/3,
      ),
      shrinkWrap: true,
      physics:  const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty?
      allCharacters.length :
      searchedForCharacters.length,
      itemBuilder: (ctx,index){
        return CharacterItem(
          character: _searchTextController.text.isEmpty?
          allCharacters[index] :
          searchedForCharacters[index],);
      },
    );
  }

  Widget _buildAppBarTitle(){
    return Text(
      'Characters',
      style: TextStyle(color: MyColors.MyWhite),
    );
   }

  Widget buildNoInternetWidget(){
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Can\'t Connect ... Check Internet',
              style: TextStyle(
                fontSize: 22,
                color: MyColors.MyBlueGrey,
              ),
            ),
          Image.asset('assets/images/warning.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.MyGrey,
      appBar: AppBar(
        backgroundColor: MyColors.MyGrey,
        centerTitle: true,
        leading: _isSearching? BackButton(color: MyColors.MyBlueGrey,): Container(),
        actions: _buildAppBarActions(),
        title: _isSearching?
        _buildSearchField() : _buildAppBarTitle(),
      ),
      body: OfflineBuilder(
      connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity,
      Widget child,
    ){
        final bool connected = connectivity != ConnectivityResult.none;
        if(connected){
          return buildBlocWidget();
        }else{
          return buildNoInternetWidget();
        }
      },
      child: showLoadingIndicator(),
      ),
    );
  }
}
