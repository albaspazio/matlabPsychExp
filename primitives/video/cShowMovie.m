classdef cShowMovie < handle
    
    
    properties (Access = protected)
        start_on_creation = 1

        video_timer_id;
        audio_timer_id;
        trigger_timer_id;

        video_timer_period;
        audio_timer_period;
        trigger_timer_period;
        
        % video 
        video_matrix;
        framerate;
        num_frames;
        duration;
        win;
        rotation
        input_rect
        output_rect
        
    end
    
    methods
        function this = cShowMovie(varargin)
            
            if not(isempty(varargin))
                for par=1:2:length(varargin)
                    if isempty(varargin{par+1})
                        continue;
                    else
                        value = varargin{par+1};
                        switch varargin{par}
                            case 'win'
                                this.win        = value;
                            case 'start_on_creation'
                                this.start_on_creation  = value;
                        end
                    end
                end            
            end            
            
            if this.start_on_creation
                this.startTimer();
            end
        end
        
        function this = startTimer(this)
            this.timer_id1 = timer( 'TimerFcn', @this.timer_callback1, ...
                                    'StopFcn', @this.stop_callback1, ...
                                    'StartFcn', @this.start_callback1, ...
                                    'name', 'test_timer_name','Period', this.timerPeriod, 'StartDelay', this.timerPeriod, 'TasksToExecute', this.num_timer_rep, 'BusyMode','drop','ExecutionMode','fixedRate');
                                    
            start(this.timer_id1); 
        end

        
        function this = stopTimer(this, timer_obj)
            if ~isempty(timer_obj) && strcmp(timer_obj.Running, 'on')
                    stop(timer_obj);
            end            
        end

        function delete(this)
            if ~isempty(this.timer_id1)
                if strcmp(this.timer_id1.Running,'on')
                    stop(this.timer_id1);
                end
                delete(this.timer_id1);
            end
               
            if ~isempty(this.timer_id2) 
                if strcmp(this.timer_id2.Running,'on')
                    stop(this.timer_id2);
                end
                delete(this.timer_id2);
            end            
        end
        
    end
    %%---------------------------------------------------------------------------------------------------------------
    %% PROTECTED
    methods (Access = protected)
        
        function start_callback1(this, ~, event)   % is called immediately after the start, regardless of 'StartDelay' parameter, which reflect only the first timeFcn call
            strtime = datestr(event.Data.time, 'HH:MM');
            disp(['start at: ' strtime ':' num2str(event.Data.time(6))]);
        end       
        
        
        function timer_callback1(this, obj, event)
            str_time                    = datestr(event.Data.time, 'HH:MM');
            str_elapsed                 = num2str(obj.InstantPeriod);
            disp(['iteration num: ' num2str(obj.TasksExecuted) ' at: ' str_time ':' num2str(event.Data.time(6)) ', time elapsed: ' str_elapsed]);
        end       

        function stop_callback1(this, obj, event)
            strtime                     = datestr(event.Data.time, 'HH:MM');
            str_elapsed                 = num2str(obj.InstantPeriod);
            disp(['stop at: ' strtime ':' num2str(event.Data.time(6)) ', time elapsed: ' str_elapsed]);
            
            stop(obj);
        end       
    end
end