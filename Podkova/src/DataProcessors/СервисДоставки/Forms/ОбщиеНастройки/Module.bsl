
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СервисДоставки.ПравоРаботыССервисомДоставки(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Если НЕ ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоТипуГрузоперевозки();
	
	ДоступнаОтправкаЗаказовНаДоставку = СервисДоставки.ПравоОтправкиЗаказовНаДоставкуПеревозчику();
	
	Если Не ДоступнаОтправкаЗаказовНаДоставку Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Недостаточно прав для работы с настройками.
			|Должна быть доступна роль ""Отправка заказов на доставку перевозчику""'"));
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанныеСервиса();
	ЗаполнитьДанныеПоУмолчанию();
	
	СервисДоставкиПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РазмерГабаритПриИзменении(Элемент)
	
	ПриИзмененииГабарита(ЭтотОбъект, ПостфиксЭлемента(Элемент));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ТекстОшибки = "";
	Отказ = Ложь;
	
	Если Модифицированность Тогда
		
		Если Не Отказ Тогда
			ЗаписатьНастройкиПоУмолчанию(Отказ, ТекстОшибки);
		КонецЕсли;
		
		Если Не Отказ Тогда
			Модифицированность = Ложь;
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитовФормы

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииГабарита(Форма, ПостФикс)
	
	Форма["Объем" + ПостФикс] = 
		Форма["Длина" + ПостФикс] * Форма["Ширина" + ПостФикс] * Форма["Высота" + ПостФикс]/1000000;
	
КонецПроцедуры

#КонецОбласти

#Область ОрганизацияБизнесСети

&НаСервереБезКонтекста
Функция ОрганизацииБизнесСетиНаСервере()
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(СервисДоставкиСлужебный.ОрганизацииБизнесСети());
	
КонецФункции

&НаСервере
Процедура СписокОрганизацийБизнесСети()
	
	СписокОрганизаций = Элементы.Организация.СписокВыбора;
	СписокОрганизаций.Очистить();
	ОрганизацииБизнесСети = ОрганизацииБизнесСетиНаСервере();
	Для Каждого Строка Из ОрганизацииБизнесСети Цикл
		СписокОрганизаций.Добавить(Строка.Организация, Строка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьДанныеСервиса()
	
	СписокОрганизацийБизнесСети();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоУмолчанию()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НастройкиДоставки.НаименованиеПараметра КАК НаименованиеПараметра,
	               |	НастройкиДоставки.Значение КАК Значение
	               |ИЗ
	               |	РегистрСведений.НастройкиОбщиеСервисДоставки КАК НастройкиДоставки
	               |ГДЕ
	               |	НастройкиДоставки.ТипГрузоперевозки = &ТипГрузоперевозки";
	
	Запрос.УстановитьПараметр("ТипГрузоперевозки", ТипГрузоперевозки);
	ДанныеПоУмолчанию = Запрос.Выполнить().Выбрать();
	
	Пока ДанныеПоУмолчанию.Следующий() Цикл
		
		Если ДанныеПоУмолчанию.НаименованиеПараметра = "ОрганизацияБизнесСети" Тогда
			ОрганизацияБизнесСети = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ВысотаЕдиницыТовара" Тогда
			ВысотаЕдиницыТовара = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ДлинаЕдиницыТовара" Тогда
			ДлинаЕдиницыТовара = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ШиринаЕдиницыТовара" Тогда
			ШиринаЕдиницыТовара = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ВесЕдиницыТовара" Тогда
			ВесЕдиницыТовара = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ВысотаГрузовогоМеста" Тогда
			ВысотаГрузовогоМеста = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ДлинаГрузовогоМеста" Тогда
			ДлинаГрузовогоМеста = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ШиринаГрузовогоМеста" Тогда
			ШиринаГрузовогоМеста = ДанныеПоУмолчанию.Значение;
		ИначеЕсли ДанныеПоУмолчанию.НаименованиеПараметра = "ВесГрузовогоМеста" Тогда
			ВесГрузовогоМеста = ДанныеПоУмолчанию.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	ПриИзмененииГабарита(ЭтотОбъект, "ЕдиницыТовара");
	ПриИзмененииГабарита(ЭтотОбъект, "ГрузовогоМеста");
	
КонецПроцедуры

#Область ЗаписьНастроек

&НаСервере
Процедура ЗаписатьНастройкиПоУмолчанию(Отказ, ТекстОшибки)
	
	Попытка
		
		НаборЗаписей = РегистрыСведений.НастройкиОбщиеСервисДоставки.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ТипГрузоперевозки.Установить(ТипГрузоперевозки);
		
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ОрганизацияБизнесСети");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВесЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВысотаЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ДлинаЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ШиринаЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВесГрузовогоМеста");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВысотаГрузовогоМеста");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ДлинаГрузовогоМеста");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ШиринаГрузовогоМеста");
		
		НаборЗаписей.Записать(Истина);
		
	Исключение
		
		Отказ = Истина;
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, НаименованиеПараметра)
	
	Если ЗначениеЗаполнено(ЭтотОбъект[НаименованиеПараметра]) Тогда
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.НаименованиеПараметра = НаименованиеПараметра;
		НоваяЗапись.ТипГрузоперевозки = НаборЗаписей.Отбор.ТипГрузоперевозки.Значение;
		НоваяЗапись.Значение = ЭтотОбъект[НаименованиеПараметра];
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Функция ПостфиксЭлемента(Элемент)
	
	Если СтрНайти(Элемент.Имя, "ЕдиницыТовара") > 0 Тогда
		Возврат "ЕдиницыТовара";
	Иначе
		Возврат "ГрузовогоМеста";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НастроитьФормуПоТипуГрузоперевозки()
	
	Если ТипГрузоперевозки = 1 Тогда
		Заголовок = НСтр("ru = '1C:Доставка: Общие настройки'");
	Иначе
		Заголовок = НСтр("ru = '1C:Курьер: Общие настройки'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
