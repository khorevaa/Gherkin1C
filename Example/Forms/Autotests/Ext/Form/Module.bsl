﻿#Область НаборТестов

&НаКлиенте
Процедура ЗаполнитьНаборТестов(ЮнитТест, Интерактивно = Ложь) Экспорт
	
	ЮнитТест.Добавить("Тест_ИнициализацияБиблиотеки", "Инициализация библиотеки");
	ЮнитТест.Добавить("Тест_ПарсингПримитивногоСценария", "Парсинг примитивного сценария");
	
КонецПроцедуры

&НаКлиенте
Процедура Тест_ИнициализацияБиблиотеки(Ожидается) Экспорт
	
	ИмяКомпоненты = "AddIn." + Ожидается.ИдентификаторКомпоненты + ".GherkinParser";
	ВК = Ожидается.Тест().Компонента("GherkinParser").ИмеетТип(ИмяКомпоненты).Вернуть();

	КлючевыеСлова = ПолучитьКлючевыеСлова();
	Ожидается.Тест().Что(ВК).Установить("КлючевыеСлова", КлючевыеСлова);
	
КонецПроцедуры

&НаКлиенте
Процедура Тест_ПарсингПримитивногоСценария(Ожидается) Экспорт
	
	ВК = Ожидается.Тест().Компонента("GherkinParser").Вернуть();
	
	ТекстСценария =
	"# language: ru
	|# encoding: utf-8
	|# Пример комментария
	|# Второй комментарий
	|@tree
	|@TagValue
	|Функциональность: Автотест
	|	Описание функционала
	|   простого сценария
	|";
	
	
	ДанныеФайла = Ожидается.Тест("Парсинг строки").Что(ВК).Функц("Прочитать", ТекстСценария).JSON().Вернуть();
	
	Ожидается.Тест("Язык сценария").Что(ДанныеФайла).Получить("language").Равно("ru");
	ДанныеФичи = Ожидается.Тест("Данные фичи").Что(ДанныеФайла).Получить("feature").Вернуть();
	Ожидается.Тест("Заголовок фичи").Что(ДанныеФичи).Получить("name").Равно("Автотест");
	
	Ожидается.Тест("Пример комментария").Что(ДанныеФичи).Получить("comments", 0).Равно("Пример комментария");
	Ожидается.Тест("Второй комментарий").Что(ДанныеФичи).Получить("comments", 1).Равно("Второй комментарий");
	
	Ожидается.Тест("Первый тэг @tree").Что(ДанныеФичи).Получить("tags", 0).Равно("tree");
	Ожидается.Тест("Второй тэг @TagValue").Что(ДанныеФичи).Получить("tags", 1).Равно("TagValue");
	
	Ожидается.Тест("Первая строка описания").Что(ДанныеФичи).Получить("description", 0).Равно("Описание функционала");
	Ожидается.Тест("Вторая строка описания").Что(ДанныеФичи).Получить("description", 1).Равно("простого сценария");
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	ЗаписьТекста = Новый ЗаписьТекста(ВременныйФайл, КодировкаТекста.UTF8);
	ЗаписьТекста.Записать(ТекстСценария);
	ЗаписьТекста.Закрыть();
	
	Ожидается.Тест("Парсинг файла сценария").Что(ВК).Функц("ПрочитатьФайл", ВременныйФайл).Получить("feature").Получить("name").Равно("Автотест");
	УдалитьФайлы(ВременныйФайл);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедуры

&НаСервере
Функция ПолучитьМакетОбработки(ИмяМакета)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	КлючевыеСлова = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	Возврат ПоместитьВоВременноеХранилище(КлючевыеСлова, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Функция ПолучитьКлючевыеСлова()

	АдресХранилища = ПолучитьМакетОбработки("Keywords");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
	УдалитьИзВременногоХранилища(АдресХранилища);
	Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения();
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	УдалитьФайлы(ИмяВременногоФайла);
	ИмяВременнойПапки = ИмяВременногоФайла + ПолучитьРазделительПути();
	ЧтениеZipФайла = Новый ЧтениеZipФайла(Поток);
	Для каждого ЭлементZip из ЧтениеZipФайла.Элементы Цикл
		ЧтениеZipФайла.Извлечь(ЭлементZip, ИмяВременнойПапки);
		ИмяВременногоФайла = ИмяВременнойПапки + ЭлементZip.ПолноеИмя;
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
		Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения();
		ЧтениеТекста = Новый ЧтениеТекста(Поток, КодировкаТекста.UTF8);
		ТекстМакета = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		УдалитьФайлы(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременнойПапки);
		Возврат ТекстМакета;
	КонецЦикла;
	
КонецФункции

#КонецОбласти