//MIT License

//Copyright (c) 2023 Anton Tsitavets

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#Область Бот

Функция ПолучитьИнформациюБота(Знач Токен) Экспорт
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/getMe"); 
    Возврат Ответ;

Конецфункции

Функция ПолучитьОбновления(Знач Токен) Экспорт
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/getUpdates");    
    Возврат Ответ;

КонецФункции

Функция РазбитьЗапросВСтруктуру(Знач HttpЗапрос) Экспорт
	
	ЧтениеJSON 	= Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(HttpЗапрос.ПолучитьТелоКакСтроку());
	
	СтруктураПараметровВходная  = ПрочитатьJSON(ЧтениеJSON);
	СтруктураПараметровВыходная = Новый Структура;
	
	
	
	Возврат СтруктураПараметровВыходная;
	
КонецФункции

Функция ОбработатьДанные(Знач Запрос) Экспорт
	
	ЧтениеJSON 	= Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
	
	СтруктураПараметровВходная  = ПрочитатьJSON(ЧтениеJSON);
	СтруктураПараметровВыходная = Новый Структура;
	СтруктураПараметровВыходная.Вставить("Вид");
	СтруктураПараметровВыходная.Вставить("Никнейм");
	СтруктураПараметровВыходная.Вставить("IDПользователя");
	СтруктураПараметровВыходная.Вставить("IDСообщения");
	СтруктураПараметровВыходная.Вставить("IDЧата");
	СтруктураПараметровВыходная.Вставить("Сообщение");	
	СтруктураПараметровВыходная.Вставить("Дата");                                     
	СтруктураПараметровВыходная.Вставить("БотОтключен");
	
	Если СтруктураПараметровВходная.Свойство("message") Тогда
 
		СтруктураСообщения 	= СтруктураПараметровВходная["message"];
		СтруктураПользователя 	= СтруктураСообщения["from"];
		СтруктураЧата		= СтруктураСообщения["chat"];
		
		СтруктураПараметровВыходная.Вставить("Вид"			, "Сообщение");
		СтруктураПараметровВыходная.Вставить("Никнейм"             	, СтруктураПользователя["username"]);
		СтруктураПараметровВыходная.Вставить("IDПользователя"		, СтруктураПользователя["id"]);
		СтруктураПараметровВыходная.Вставить("IDСообщения"	        , СтруктураСообщения["message_id"]);
		СтруктураПараметровВыходная.Вставить("IDЧата"			, СтруктураЧата["id"]);
		СтруктураПараметровВыходная.Вставить("Сообщение"		, СтруктураСообщения["text"]);
		СтруктураПараметровВыходная.Вставить("Дата"			, Дата(1970,1,1,1,0,0) + СтруктураСообщения["date"]);
		СтруктураПараметровВыходная.Вставить("БотОтключен"		, Ложь);
		
	ИначеЕсли СтруктураПараметровВходная.Свойство("my_chat_member") Тогда
		
		СтруктураСообщения      = СтруктураПараметровВходная["my_chat_member"];
		СтруктураПользователя 	= СтруктураСообщения["from"];
		СтруктураЧата		= СтруктураСообщения["chat"];
		
		СтруктураПараметровВыходная.Вставить("Вид"			, "Запуск/Остановка");
		СтруктураПараметровВыходная.Вставить("Никнейм"             	, СтруктураПользователя["username"]);
		СтруктураПараметровВыходная.Вставить("IDПользователя"		, СтруктураПользователя["id"]);
		СтруктураПараметровВыходная.Вставить("IDСообщения"		, "");
		СтруктураПараметровВыходная.Вставить("IDЧата"			, СтруктураЧата["id"]);
		СтруктураПараметровВыходная.Вставить("Сообщение"		, СтруктураСообщения["new_chat_member"]["status"]);
		СтруктураПараметровВыходная.Вставить("Дата"			, Дата(1970,1,1,1,0,0) + СтруктураСообщения["date"]);
		СтруктураПараметровВыходная.Вставить("БотОтключен"		, ?(СтруктураСообщения["new_chat_member"]["status"] = "kicked", Истина, Ложь));

	ИначеЕсли СтруктураПараметровВходная.Свойство("callback_query") Тогда
		
		
		СтруктураСообщения 	= СтруктураПараметровВходная["callback_query"];
		СтруктураПользователя 	= СтруктураСообщения["from"];

		СтруктураПараметровВыходная.Вставить("Вид"			, "Кнопка под сообщением");
		СтруктураПараметровВыходная.Вставить("Никнейм"             	, СтруктураПользователя["username"]);
		СтруктураПараметровВыходная.Вставить("IDПользователя"		, СтруктураПользователя["id"]);
		СтруктураПараметровВыходная.Вставить("IDСообщения"		, СтруктураСообщения["message"]["message_id"]);
		СтруктураПараметровВыходная.Вставить("IDЧата"			, СтруктураСообщения["message"]["chat"]["id"]);
		СтруктураПараметровВыходная.Вставить("Сообщение"		, СтруктураСообщения["data"]);
		СтруктураПараметровВыходная.Вставить("Дата"			, Дата(1970,1,1,1,0,0) + СтруктураСообщения["message"]["date"]);
		СтруктураПараметровВыходная.Вставить("БотОтключен"		, Ложь);
 
	КонецЕсли;
	
	Возврат СтруктураПараметровВыходная;
	                        
КонецФункции

#КонецОбласти


#Область Диалоги

Функция ОтправитьТекстовоеСообщение(Знач Токен, Знач IDЧата, Знач Текст, Знач Клавиатура = "") Экспорт
    
    ЗаменитьСпецсимволы(Текст);
    IDЧата = Инструменты.ЧислоВСтроку(IDЧата);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"    , "Markdown");
    _Параметры.Вставить("text"          , Текст);
    _Параметры.Вставить("chat_id"       , IDЧата);
    _Параметры.Вставить("reply_markup"  , Клавиатура);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/sendMessage", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

Функция ОтправитьКартинку(Знач Токен, Знач IDЧата, Знач Текст, Знач Картинка, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Картинка, "photo", Клавиатура);
    
КонецФункции

Функция ОтправитьВидео(Знач Токен, Знач IDЧата, Знач Текст, Знач Видео, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Видео, "video", Клавиатура);
    
КонецФункции

Функция ОтправитьАудио(Знач Токен, Знач IDЧата, Знач Текст, Знач Аудио, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Аудио, "audio", Клавиатура);
    
КонецФункции

Функция ОтправитьДокумент(Знач Токен, Знач IDЧата, Знач Текст, Знач Документ, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Документ, "document", Клавиатура);
    
КонецФункции

Функция ОтправитьГифку(Знач Токен, Знач IDЧата, Знач Текст, Знач Гифка, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Гифка, "animation", Клавиатура);
    
КонецФункции

Функция ОтправитьНаборЛюбыхФайлов(Знач Токен, Знач IDЧата, Знач Текст, Знач СоответствиеФайлов, Знач Клавиатура = "") Экспорт
    
    //СоответствиеФайлов
    //Ключ - Файл, Значение - Тип
    //Типы: audio, document, photo, video
    //Нельзя замешивать audio и document вместе с другими типами!
    
    ЗаменитьСпецсимволы(Текст);
    
    IDЧата          = Инструменты.ЧислоВСтроку(IDЧата);
    СтруктураФайлов = Новый Структура;
    Медиа           = Новый Массив; 
    Счетчик         = 0;
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"    , "Markdown");
    _Параметры.Вставить("caption"       , Текст);
    _Параметры.Вставить("chat_id"       , IDЧата);
    _Параметры.Вставить("reply_markup"  , Клавиатура);
    
    
    Для Каждого ТекущийФайл Из СоответствиеФайлов Цикл
        
        Если Не ТипЗнч(ТекущийФайл.Ключ) = Тип("ДвоичныеДанные") Тогда      
            ДД              = Новый ДвоичныеДанные(ТекущийФайл.Ключ);   
            ЭтотФайл        = Новый Файл(ТекущийФайл.Ключ);
            ИмяМедиа        = ТекущийФайл.Значение 
                    + Строка(Счетчик) 
                    + ?(ТекущийФайл.Значение = "document", ЭтотФайл.Расширение, "");
            ПолноеИмяМедиа  = СтрЗаменить(ИмяМедиа, ".", "___");
        Иначе
            ДД              = ТекущийФайл.Ключ;
            ИмяМедиа        = ТекущийФайл.Значение + Строка(Счетчик);
            ПолноеИмяМедиа  = ИмяМедиа;
        КонецЕсли;
        
        СтруктураФайлов.Вставить(ПолноеИмяМедиа ,  ДД);
        
        СтруктураМедиа = Новый Структура;
        СтруктураМедиа.Вставить("type", ТекущийФайл.Значение);
        СтруктураМедиа.Вставить("media", "attach://" + ИмяМедиа);
        
        Если Счетчик = 0 Тогда
            СтруктураМедиа.Вставить("caption", Текст);
        КонецЕсли;
        
        Медиа.Добавить(СтруктураМедиа);
        
        Счетчик = Счетчик + 1;
        
    КонецЦикла;
    
    _Параметры.Вставить("media", Инструменты.JSONСтрокой(Медиа));
    
    Ответ = Инструменты.Post("api.telegram.org/bot" 
        + Токен 
        + "/sendMediaGroup", _Параметры, СтруктураФайлов, "mixed"); 

    
    Возврат Ответ;
    
КонецФункции

Функция ОтправитьМестоположение(Знач Токен, Знач IDЧата, Знач Широта, Знач Долгота, Знач Клавиатура = "") Экспорт
    
    IDЧата = Инструменты.ЧислоВСтроку(IDЧата);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"    , "Markdown");
    _Параметры.Вставить("chat_id"       , IDЧата);
    _Параметры.Вставить("latitude"      , Инструменты.ЧислоВСтроку(Широта));
    _Параметры.Вставить("longitude"     , Инструменты.ЧислоВСтроку(Долгота));
    _Параметры.Вставить("reply_markup"  , Клавиатура);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/sendLocation", _Параметры);
    
    Возврат Ответ;
    

КонецФункции

Функция ОтправитьКонтакт(Знач Токен, Знач IDЧата, Знач Имя, Знач Фамилия, Знач Телефон, Знач Клавиатура = "") Экспорт
    
    IDЧата = Инструменты.ЧислоВСтроку(IDЧата);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"    , "Markdown");
    _Параметры.Вставить("chat_id"       , IDЧата);
    _Параметры.Вставить("first_name"    , Имя);
    _Параметры.Вставить("last_name"     , Фамилия);
    _Параметры.Вставить("phone_number"  , Строка(Телефон));
    _Параметры.Вставить("reply_markup"  , Клавиатура);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/sendContact", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

Функция ОтправитьОпрос(Знач Токен, Знач IDЧата, Знач Вопрос, Знач МассивОтветов, Знач Анонимный = Истина) Экспорт
    
    IDЧата = Инструменты.ЧислоВСтроку(IDЧата);
    Ответы = Инструменты.JSONСтрокой(МассивОтветов);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"        , "Markdown");
    _Параметры.Вставить("chat_id"           , IDЧата);
    _Параметры.Вставить("question"          , Вопрос);
    _Параметры.Вставить("options"           , Ответы);
    _Параметры.Вставить("is_anonymous"      , Анонимный);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/sendPoll", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

Функция ПереслатьСообщение(Знач Токен, Знач IDОригинала, Знач ОткудаID, Знач КудаID) Экспорт
    
    IDОригинала     = Инструменты.ЧислоВСтроку(IDОригинала);
    ОткудаID        = Инструменты.ЧислоВСтроку(ОткудаID);
    КудаID          = Инструменты.ЧислоВСтроку(КудаID);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("chat_id"       , КудаID);
    _Параметры.Вставить("from_chat_id"  , ОткудаID);
    _Параметры.Вставить("message_id"    , IDОригинала);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/forwardMessage", _Параметры);
    
    Возврат Ответ;

КонецФункции

#КонецОбласти


#Область Администрирование

Функция Бан(Знач Токен, Знач IDЧата, Знач IDПользователя) Экспорт
    
    IDЧата          = Инструменты.ЧислоВСтроку(IDЧата);
    IDПользователя  = Инструменты.ЧислоВСтроку(IDПользователя);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"    , "Markdown");
    _Параметры.Вставить("chat_id"       , IDЧата);
    _Параметры.Вставить("user_id"       , IDПользователя);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/banChatMember", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

Функция Разбан(Знач Токен, Знач IDЧата, Знач IDПользователя) Экспорт
    
    IDЧата          = Инструменты.ЧислоВСтроку(IDЧата);
    IDПользователя  = Инструменты.ЧислоВСтроку(IDПользователя);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"        , "Markdown");
    _Параметры.Вставить("chat_id"           , IDЧата);
    _Параметры.Вставить("user_id"           , IDПользователя);
    _Параметры.Вставить("only_if_banned"    , Истина);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/unbanChatMember", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

Функция СоздатьСсылкуПриглашение(Знач Токен, Знач IDЧата, Знач Заголовок = "", Знач ДатаИстечения = "", Знач ЛимитПользователей = 0) Экспорт
    
    IDЧата          = Инструменты.ЧислоВСтроку(IDЧата);
    IDПользователя  = Инструменты.ЧислоВСтроку(IDПользователя);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"        , "Markdown");
    _Параметры.Вставить("chat_id"           , IDЧата);
    _Параметры.Вставить("name"              , Заголовок);
	
	Если ЗначениеЗаполнено(ДатаИстечения) Тогда
        _Параметры.Вставить("expire_date"       , Формат(ДатаИстечения - Дата(1970,1,1,1,0,0), "ЧГ=0"));
	КонецЕсли;
	
    _Параметры.Вставить("member_limit"      , ЛимитПользователей);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/createChatInviteLink", _Параметры);
    
    Возврат Ответ;

КонецФункции

Функция ЗакрепитьСообщение(Знач Токен, Знач IDЧата, Знач IDСообщения) Экспорт
    
    IDЧата          = Инструменты.ЧислоВСтроку(IDЧата);
    IDСообщения     = Инструменты.ЧислоВСтроку(IDСообщения);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"            , "Markdown");
    _Параметры.Вставить("chat_id"               , IDЧата);
    _Параметры.Вставить("message_id"            , IDСообщения);
    _Параметры.Вставить("disable_notification"  , Истина);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/pinChatMessage", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

Функция ОткрепитьСообщение(Знач Токен, Знач IDЧата, Знач IDСообщения) Экспорт
    
    IDЧата          = Инструменты.ЧислоВСтроку(IDЧата);
    IDСообщения     = Инструменты.ЧислоВСтроку(IDСообщения);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"            , "Markdown");
    _Параметры.Вставить("chat_id"               , IDЧата);
    _Параметры.Вставить("message_id"            , IDСообщения);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/unpinChatMessage", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

Функция ПолучитьЧислоУчастников(Знач Токен, Знач IDЧата) Экспорт
    
    IDЧата          = Инструменты.ЧислоВСтроку(IDЧата);
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"            , "Markdown");
    _Параметры.Вставить("chat_id"               , IDЧата);
    
    Ответ = Инструменты.Get("api.telegram.org/bot" + Токен + "/getChatMemberCount", _Параметры);
    
    Возврат Ответ;
    
КонецФункции

#КонецОбласти

#Область TelegramMiniApp

Функция ОбработатьДанныеTMA(Знач СтрокаДанных, Знач Токен) Экспорт    
	
	СтрокаДанных    = РаскодироватьСтроку(СтрокаДанных, СпособКодированияСтроки.КодировкаURL);
	СтруктураДанных = ПараметрыЗапросаВСоответствие(СтрокаДанных);
	Ключ            = "WebAppData";
	Хэш             = "";
	
	Результат = HMACSHA256(ПолучитьДвоичныеДанныеИзСтроки(Ключ), ПолучитьДвоичныеДанныеИзСтроки(Токен)); 
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Ключ");
	ТЗ.Колонки.Добавить("Значение");
	
	Для Каждого Данные Из СтруктураДанных Цикл
		
		НоваяСтрока 	        = ТЗ.Добавить();		
		НоваяСтрока.Ключ 		= Данные.Ключ;
		НоваяСтрока.Значение 	= Данные.Значение;
		
	КонецЦикла;
	
	ТЗ.Сортировать("Ключ");
	
	СоответствиеВозврата = Новый Соответствие;
	DCS 			  	 = "";
	
	Для Каждого СтрокаТЗ Из ТЗ Цикл
		
		Если СтрокаТЗ.Ключ <> "hash" Тогда
			DCS = DCS + СтрокаТЗ.Ключ + "=" + СтрокаТЗ.Значение + Символы.ПС;
			СоответствиеВозврата.Вставить(СтрокаТЗ.Ключ, СтрокаТЗ.Значение); 
		Иначе
			Хэш = СтрокаТЗ.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	DCS 	= Лев(DCS, СтрДлина(DCS) - 1);
	Подпись = HMACSHA256(Результат, ПолучитьДвоичныеДанныеИзСтроки(DCS));
	
	Финал = ПолучитьHexСтрокуИзДвоичныхДанных(Подпись);
	
	Если Финал = вРег(Хэш) Тогда
		Ответ = Истина;
	Иначе
		Ответ = Ложь;
	КонецЕсли;
	
	СоответствиеВозврата.Вставить("passed", Ответ);
	
	Возврат СоответствиеВозврата;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция СформироватьКлавиатуруПоМассивуКнопок(Знач МассивКнопок, Знач ПодСообщением = Ложь) Экспорт
    
    Строки = Новый Массив;
        
    Для Каждого Кнопка Из МассивКнопок Цикл
        
        Кнопки = Новый Массив;
        Кнопка = КодироватьСтроку(Инструменты.ЧислоВСтроку(Кнопка), СпособКодированияСтроки.КодировкаURL);
        Кнопки.Добавить(Новый Структура("text,callback_data", Кнопка, Кнопка));
        Строки.Добавить(Кнопки);

    КонецЦикла;
    
    
    Если ПодСообщением Тогда
        СтруктураПараметра = Новый Структура("inline_keyboard,rows", Строки, 1);
    Иначе
        СтруктураПараметра = Новый Структура("keyboard,resize_keyboard", Строки, Истина)
    КонецЕсли;
    
        
    ЗаписьJSON = Новый ЗаписьJSON;
    ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет,,,ЭкранированиеСимволовJSON.СимволыВнеASCII));
    ЗаписатьJSON(ЗаписьJSON, СтруктураПараметра);
    
    Возврат ЗаписьJSON.Закрыть();
    
КонецФункции

#КонецОбласти

#Область Служебные

Функция ЗаменитьСпецСимволы(Текст) 
    
    МассивСимволов = Новый Соответствие;
    МассивСимволов.Вставить("<", "&lt;");
    МассивСимволов.Вставить(">", "&gt;");
    МассивСимволов.Вставить("&", "&amp;");
    МассивСимволов.Вставить("_", " ");
    МассивСимволов.Вставить("[", "(");
    МассивСимволов.Вставить("]", ")");
    
    Для Каждого СимволМассива Из МассивСимволов Цикл
        Текст = СтрЗаменить(Текст, СимволМассива.Ключ, СимволМассива.Значение);
    КонецЦикла;
    
КонецФункции

Функция ОтправитьФайл(Знач Токен, Знач IDЧата, Знач Текст, Знач Файл, Знач Вид, Знач Клавиатура) Экспорт
    
    Если Вид = "photo" Тогда
        Метод = "/sendPhoto";
    ИначеЕсли Вид = "video" Тогда
        Метод = "/sendVideo";
    ИначеЕсли Вид = "audio" Тогда
        Метод = "/sendAudio";
    ИначеЕсли Вид = "document" Тогда
        Метод   = "/sendDocument";
    ИначеЕсли Вид = "animation" Тогда
        Метод = "/sendAnimation";
    Иначе 
        Возврат "";
    КонецЕсли;
    
    ЗаменитьСпецсимволы(Текст);
    IDЧата = Инструменты.ЧислоВСтроку(IDЧата);
    
    Если Не ТипЗнч(Файл) = Тип("ДвоичныеДанные") Тогда      
        ТекущийФайл = Новый Файл(Файл);
        Расширение  = ?(Вид = "document", ТекущийФайл.Расширение, "");
        Файл        = Новый ДвоичныеДанные(Файл);   
    Иначе
        Расширение  = "";
    КонецЕсли;
    
    Расширение = СтрЗаменить(Расширение, ".", "___");
    
    _Параметры = Новый Структура;
    _Параметры.Вставить("parse_mode"    , "Markdown");
    _Параметры.Вставить("caption"       , Текст);
    _Параметры.Вставить("chat_id"       , IDЧата);
    _Параметры.Вставить("reply_markup"  , Клавиатура);
    
    СтруктураФайлов = Новый Структура;
    СтруктураФайлов.Вставить(Вид + Расширение,  Файл);
    
    Ответ = Инструменты.Post("api.telegram.org/bot" 
    + Токен 
    + Метод, _Параметры, СтруктураФайлов, "mixed"); 
    
    
    Возврат Ответ;
    
КонецФункции

Функция ПараметрыЗапросаВСоответствие(Знач СтрокаПараметров) Экспорт
	
	СоответствиеВозврата = Новый Соответствие;
	КоличествоЧастей	 = 2;
	МассивПараметров     = СтрРазделить(СтрокаПараметров, "&", Ложь);
	
	Для Каждого Параметр Из МассивПараметров Цикл
		
		МассивКлючЗначение = СтрРазделить(Параметр, "=");
		
		
		Если МассивКлючЗначение.Количество() = КоличествоЧастей Тогда
			СоответствиеВозврата.Вставить(МассивКлючЗначение[0]
				, МассивКлючЗначение[1]);
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СоответствиеВозврата;
	
КонецФункции

#КонецОбласти

#Область БСП

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

Функция HMACSHA256(Знач Ключ, Знач Данные)
	
	Возврат HMAC(Ключ, Данные, ХешФункция.SHA256, 64);
	
КонецФункции

Функция Хеш(ДвоичныеДанные, Тип)
	
	Хеширование = Новый ХешированиеДанных(Тип);
	Хеширование.Добавить(ДвоичныеДанные);
	
	Возврат Хеширование.ХешСумма;
		
КонецФункции

Функция HMAC(Знач Ключ, Знач Данные, Тип, РазмерБлока)
	
	Если Ключ.Размер() > РазмерБлока Тогда
		Ключ = Хеш(Ключ, Тип);
	КонецЕсли;
	
	Если Ключ.Размер() <= РазмерБлока Тогда
		Ключ = ПолучитьHexСтрокуИзДвоичныхДанных(Ключ);
		Ключ = Лев(Ключ + ПовторитьСтроку("00", РазмерБлока), РазмерБлока * 2);
	КонецЕсли;
	
	Ключ = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзHexСтроки(Ключ));
	
	ipad = ПолучитьБуферДвоичныхДанныхИзHexСтроки(ПовторитьСтроку("36", РазмерБлока));
	opad = ПолучитьБуферДвоичныхДанныхИзHexСтроки(ПовторитьСтроку("5c", РазмерБлока));
	
	ipad.ЗаписатьПобитовоеИсключительноеИли(0, Ключ);
	ikeypad = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(ipad);
	
	opad.ЗаписатьПобитовоеИсключительноеИли(0, Ключ);
	okeypad = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(opad);
	
	Возврат Хеш(СклеитьДвоичныеДанные(okeypad, Хеш(СклеитьДвоичныеДанные(ikeypad, Данные), Тип)), Тип);
	
КонецФункции

Функция СклеитьДвоичныеДанные(ДвоичныеДанные1, ДвоичныеДанные2)
	
	МассивДвоичныхДанных = Новый Массив;
	МассивДвоичныхДанных.Добавить(ДвоичныеДанные1);
	МассивДвоичныхДанных.Добавить(ДвоичныеДанные2);
	
	Возврат СоединитьДвоичныеДанные(МассивДвоичныхДанных);
	
КонецФункции

Функция ПовторитьСтроку(Строка, Количество)
	
	Части = Новый Массив(Количество);
	Для к = 1 По Количество Цикл
		Части.Добавить(Строка);
	КонецЦикла;
	
	Возврат СтрСоединить(Части, "");
	
КонецФункции

#КонецОбласти
