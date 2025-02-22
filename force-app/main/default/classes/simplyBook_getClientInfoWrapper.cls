public class simplyBook_getClientInfoWrapper {
    
    public List<Data> data;
    public Metadata metadata;
    
    public class Metadata {
        public Integer items_count;
        public Integer pages_count;
        public Integer page;
        public Integer on_page;
        public List<Alphabet_index> alphabet_index;
    }
    
    public class Alphabet_index {
        public String letter;
        public Integer index;
    }
    
    public class Data {
        public Boolean can_be_edited;
        public Integer id;
        public String name;
        public String email;
        public String phone;
        public Object address1;
        public Object address2;
        public Object city;
        public Object zip;
        public Object country_id;
        public Object state_id;
        public String full_address;
    }
    public static simplyBook_getClientInfoWrapper parse(String json) {
        return (simplyBook_getClientInfoWrapper) System.JSON.deserialize(json, simplyBook_getClientInfoWrapper.class);
    }
}