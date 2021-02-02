﻿&НаКлиенте
Перем ИдентификаторКомпоненты, ВнешняяКомпонента;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МакетКомпоненты = ОбработкаОбъект.ПолучитьМакет("Gherkin1C");
	МестоположениеКомпоненты = ПоместитьВоВременноеХранилище(МакетКомпоненты, УникальныйИдентификатор);
	
	AddInURL = Неопределено;
	Если Параметры.Свойство("AddInURL", AddInURL) Тогда
		Файл = Новый Файл(AddInURL);
		Если Файл.Существует() Тогда
			МестоположениеКомпоненты = AddInURL;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ИдентификаторКомпоненты = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	ВыполнитьПодключениеВнешнейКомпоненты(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Автотест(Команда)
	
	ПараметрыФормы = Новый Структура("Автотестирование,ИдентификаторКомпоненты", Автотестирование, ИдентификаторКомпоненты);
	ПозицияРазделителя = СтрНайти(ИмяФормы, ".", НаправлениеПоиска.СКонца);
	НовоеИмя = Лев(ИмяФормы, ПозицияРазделителя) + "RunTests";
	ОткрытьФорму(НовоеИмя, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключениеВнешнейКомпоненты(ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеВнешнейКомпонентыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты, ИдентификаторКомпоненты, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеВнешнейКомпонентыЗавершение(Подключение, ДополнительныеПараметры) Экспорт
	
	Если Подключение Тогда
		КлючевыеСлова = ПолучитьКлючевыеСлова("Keywords")
		ВнешняяКомпонента = Новый("AddIn." + ИдентификаторКомпоненты + ".GherkinParser");
		ВнешняяКомпонента.НачатьУстановкуКлючевыеСлова(Новый ОписаниеОповещения, ПолучитьКлючевыеСлова);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолученаВерсияКомпоненты", ЭтотОбъект);
		ВнешняяКомпонента.НачатьПолучениеВерсия(ОписаниеОповещения);
	ИначеЕсли ДополнительныеПараметры = Истина Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключениеВнешнейКомпоненты", ЭтотОбъект, Ложь);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученаВерсияКомпоненты(Значение, ДополнительныеПараметры) Экспорт
	
	Заголовок = "Парсер языка Gherkin, версия " + Значение;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКлючевыеСлова(ИмяМакета)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	КлючевыеСлова = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	Поток = КлючевыеСлова.ОткрытьПотокДляЧтения();
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

&НаКлиенте
Процедура ТестКомпоненты(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученРезультатЧтения", ЭтотОбъект);
	ВнешняяКомпонента.НачатьВызовПрочитатьФайл(ОписаниеОповещения, ИсходныйФайл);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученРезультатЧтения(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ТекстJSON = РезультатВызова;
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, "  ");
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписатьJSON(ЗаписьJSON, ДанныеJSON);
	ТекстJSON = ЗаписьJSON.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораФайла", ЭтаФорма);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = "Фиче-файл (*.feature)|*.feature";
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ИсходныйФайл = ВыбранныеФайлы[0];
		ТестКомпоненты(Неопределено);
	КонецЕсли;
	
КонецПроцедуры
