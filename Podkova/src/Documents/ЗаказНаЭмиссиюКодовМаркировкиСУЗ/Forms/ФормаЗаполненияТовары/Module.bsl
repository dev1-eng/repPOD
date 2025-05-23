#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидПродукции = Параметры.ВидПродукции;
	
	Для Каждого КлючИЗначение Из Параметры.ДоступныеЭлементы Цикл
		Элементы["Группа" + КлючИЗначение.Ключ].Видимость = КлючИЗначение.Значение;
	КонецЦикла;
	
	Элементы.Шаблон.СписокВыбора.Очистить();
	ДоступныеШаблоны = ИнтеграцияИСМПКлиентСервер.ШаблоныКодовПоВидуПродукции(ВидПродукции);
	Если ДоступныеШаблоны.Количество() > 1 Тогда
		Для Каждого ЭлементСпискаЗначений Из ДоступныеШаблоны Цикл
			Элементы.Шаблон.СписокВыбора.Добавить(
				ЭлементСпискаЗначений.Значение, ЭлементСпискаЗначений.Представление);
		КонецЦикла;
	Иначе
		Элементы.ГруппаШаблон.Видимость = Ложь;
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	СтруктураРезультата = Новый Структура();
	
	СтруктураРезультата.Вставить("ПолноеОписаниеОстатков", ПолноеОписаниеОстатков);
	
	ИменаПолейУпрощенногоОписанияОстатков = ИменаПолейУпрощенногоОписанияОстатков();
	
	Для Каждого ИмяПоля Из ИменаПолейУпрощенногоОписанияОстатков Цикл
		Если ЭтотОбъект["Заполнять" + ИмяПоля] Тогда
			СтруктураРезультата.Вставить(ИмяПоля, ЭтотОбъект[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	
	Если ЗаполнятьШаблон Тогда
		СтруктураРезультата.Вставить("Шаблон", Шаблон);
	КонецЕсли;
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФорм

&НаКлиенте
Процедура ПолноеОписаниеОстатковПриИзменении(Элемент)
	
	ИменаПолейУпрощенногоОписанияОстатков = ИменаПолейУпрощенногоОписанияОстатков();
	
	Для Каждого ИмяПоля Из ИменаПолейУпрощенногоОписанияОстатков Цикл
		Элементы["Группа" + ИмяПоля].ТолькоПросмотр = ПолноеОписаниеОстатков;
		Если ПолноеОписаниеОстатков Тогда
			ЭтотОбъект["Заполнять" + ИмяПоля] = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормИСМПКлиентПереопределяемый.ПриНачалеВыбораКодТНВЭД(Элемент, ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(КодТНВЭД) Тогда
		
		КодТНВЭДТребуетВозрастнуюКатегорию = ИнтеграцияИСКлиентСервер.КодТНВЭДТребуетВозрастнуюКатегорию(
			ИнтеграцияИСКлиентСервер.КодТНВЭДДляПередачиВИСМП(КодТНВЭД, ВидПродукции));
		
		Элементы.ГруппаВозрастнаяКатегория.ТолькоПросмотр = Не КодТНВЭДТребуетВозрастнуюКатегорию;
		Элементы.ГруппаЦелевойПол.ТолькоПросмотр          = КодТНВЭДТребуетВозрастнуюКатегорию;
		
		Если КодТНВЭДТребуетВозрастнуюКатегорию Тогда
			ЗапрещенныйЭлемент = Элементы.ЗаполнятьЦелевойПол;
		Иначе
			ЗапрещенныйЭлемент = Элементы.ЗаполнятьВозрастнаяКатегория;
		КонецЕсли;
		
		ЭтотОбъект[ЗапрещенныйЭлемент.Имя] = Ложь;
		УправлениеДоступностьюСвязанныхЭлементов(ЗапрещенныйЭлемент);
		
	Иначе
		Элементы.ГруппаВозрастнаяКатегория.ТолькоПросмотр = Ложь;
		Элементы.ГруппаЦелевойПол.ТолькоПросмотр          = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьКодТНВЭДПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
	Если ЗаполнятьКодТНВЭД Тогда
		КодТНВЭДПриИзменении(Элементы.ЗаполнятьКодТНВЭД);
	Иначе
		Элементы.ГруппаВозрастнаяКатегория.ТолькоПросмотр = Ложь;
		Элементы.ГруппаЦелевойПол.ТолькоПросмотр          = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьЦелевойПолПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьМодельПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьТоварныйЗнакПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьВозрастнуюКатегориюПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСпособВводаВОборотПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьНаименованиеПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьШаблонПриИзменении(Элемент)
	
	УправлениеДоступностьюСвязанныхЭлементов(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИменаПолейУпрощенногоОписанияОстатков()
	
	Результат = Новый Массив;
	Результат.Добавить("КодТНВЭД");
	Результат.Добавить("ЦелевойПол");
	Результат.Добавить("ВозрастнаяКатегория");
	Результат.Добавить("Модель");
	Результат.Добавить("СпособВводаВОборот");
	Результат.Добавить("Наименование");
	Результат.Добавить("ТоварныйЗнак");
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура УправлениеДоступностьюСвязанныхЭлементов(Элемент)
	
	Элементы[СтрЗаменить(Элемент.Имя, "Заполнять", "")].ТолькоПросмотр = Не ЭтотОбъект[Элемент.Имя];
	
КонецПроцедуры

#КонецОбласти