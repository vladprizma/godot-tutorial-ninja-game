# godot-tutorial-ninja-game
Проект написанный при изучении игрового движка Godot по гайду MakerTech https://www.youtube.com/watch?v=0mUoRdYe0s4&amp;list=PLMQtM2GgbPEVuTgD4Ln17ombTg6EahSLr

# Список фичей которые реализованы в проекте
Top-down player movement logic<br/>
Player movement animation (idle, walk, run)<br/>
Tilemaps & tilesets<br/>
Animated tiles<br/>
Решение проблемы с главной сценой:<br/>
https://forum.godotengine.org/t/tilemap-doesnt-show-up-when-testing/12086/3<br/>
Y-sorting<br/>
Tilemap collision<br/>
Camera follow + camera w/ bounds collision<br/>
Enemies, markers<br/>
health bar, anchors, signals<br/>
knockback on hit<br/>
dust trail - https://www.youtube.com/watch?v=nSYK64iJ_AQ<br/>
collectable items <- https://www.youtube.com/watch?v=-faLYz20qtw&list=PLMQtM2GgbPEVuTgD4Ln17ombTg6EahSLr&index=19<br/>
 
# Что я нашел полезным в процессе, рекомендации полученные в процессе изучения материалов
Project Settings -> search GDScrpit -> set "Untyped Declaration" to Warn,<br/>
для увеличения скорости работы https://youtu.be/_Wo21KAD8OY?t=534, а так же осознанного использования типов данных и их изучения<br/>

# Используемые метки для комментприев в коде (используются вместе с todo)
bug - первый приоритет<br/>
ue - user expirience, 2 приоритет<br/>
fm - for me, т.е. метки для того чтобы разобраться для себя, не влияет на проект<br/>

Приоритеты созданы просто для себя, чтобы удобно было отслеживать нужные todo в проекте.<br/>

# Todo's
Bugs:<br/>
решить проблему https://github.com/godotengine/godot/issues/67164 - AtlasTexture?<br/>
почем то слайм отображается над игроком<br/>
разобраться с багом при запуске игры в веб версии из github repo > actions > deploy, где не грузится спрайт игрока

User expirience:<br/>
добавить меню с управлением и объяснением того, что можно делать<br/>
добавить границы в мире, за которые нельзя выходить <br/>
сделать возможность запуска игры в гитхабе https://youtu.be/PP12lu-C9k4?t=424<br/>
конфиги: https://steamcommunity.com/sharedfiles/filedetails/?id=3056895446<br/>
https://youtu.be/_Wo21KAD8OY?t=110 - сделать логгер, state (состояние, которое будет сохраняться)<br/>
разделить модули на: UI, data, states<br/>
добавить ускорение и выносливость<br/>
прыжок и препятствия, возможность перепрыгивать через них + падение в дыру и её перепрыгивание<br/>
игрок должен подпрыгивать при knockback (т.е. конечный вектор должен изгибаться), сделать отпрыгиваине при knockback медленнее. Для начала изучить как это работает например в terraria.<br/>

For me:<br/>
read godot code style https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html<br/>
рассмотреть asset-ы https://godotengine.org/asset-library/asset<br/>
идея игра в которой biderectional opposite walk lock (когда идешь в 2<br/>
оложные стороны одновременно) - фича и дает какую то способность<br/>
читать книгу the art of game desgin by jesse shell<br/>
ознакомиться с godot terrains<br/>
scoreboard https://www.youtube.com/watch?v=xeoP5CqAi0g<br/>
про многопоточность https://vk.com/@491582172-godot-4-mnogopotochnost<br/>
прочитать https://commonmark.org/help/ и https://docs.github.com/ru/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax<br/>
